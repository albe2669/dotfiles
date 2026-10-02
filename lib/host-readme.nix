{
  self,
  lib,
  config,
  pkgs,
  username,
  hostName,
}: let
  homeDir = config.opts.variables.homeDirectory.path;

  homeConfig = config.home-manager.users.${username};

  mkEntries = isSystem: pkgs:
    builtins.listToAttrs (
      builtins.filter (e: e.name != "") (
        map (pkg: {
          name = pkg.pname or pkg.name;
          value = {
            version = pkg.version or "unknown";
            inherit isSystem;
          };
        })
        pkgs
      )
    );

  systemPackages = config.environment.systemPackages or [];
  userPackages = homeConfig.home.packages or [];

  systemEntries = mkEntries true systemPackages;
  userEntries = mkEntries false userPackages;

  merged = userEntries // systemEntries;

  configKeys = builtins.attrNames (homeConfig.xdg.configFile or {});
  homeFileKeys = builtins.attrNames (homeConfig.home.file or {});

  lastComponent = key: builtins.baseNameOf key;

  findConfigPaths = name: let
    configMatches = builtins.filter (key: lastComponent key == name) configKeys;
    homeMatches = builtins.filter (key: lastComponent key == name) homeFileKeys;
    configPaths = map (key: "$XDG_CONFIG_HOME/${key}") configMatches;
    homePaths =
      map (
        key: let
          stripped = lib.removePrefix homeDir key;
          noLeadingSlash = lib.removePrefix "/" stripped;
        in "~/${noLeadingSlash}"
      )
      homeMatches;
    allPaths = configPaths ++ homePaths;
  in
    if builtins.length allPaths == 0
    then null
    else builtins.concatStringsSep ", " (lib.unique allPaths);

  resolveConfig = name: let
    heuristic = findConfigPaths name;
  in
    if heuristic != null
    then heuristic
    else "—";

  isNixOS = !config.opts.variables.isDarwin;

  systemdServiceNames =
    if isNixOS
    then builtins.attrNames (lib.filterAttrs (_: svc: (svc.wantedBy or []) != []) config.systemd.services)
    else [];
  resolveLog = name: let
    svcMatch = builtins.elem name systemdServiceNames;
  in
    if isNixOS && svcMatch
    then "journalctl -u ${name}"
    else "—";

  resolveCategory = name: let
    declared = self.software.${name} or null;
  in
    if declared != null
    then declared
    else "Uncategorised";

  allPackages = builtins.attrValues (
    builtins.mapAttrs (name: info: {
      inherit name;
      inherit (info) version isSystem;

      category = resolveCategory name;
      logLocation = resolveLog name;
      configLocation = resolveConfig name;
    })
    merged
  );

  grouped =
    builtins.foldl' (
      acc: pkg:
        acc
        // {
          ${pkg.category} = (acc.${pkg.category} or []) ++ [pkg];
        }
    ) {}
    allPackages;

  knownOrder = self.categories;
  remainingCategories = builtins.filter (c: !builtins.elem c knownOrder) (
    builtins.sort (a: b: a < b) (builtins.attrNames grouped)
  );
  categoryOrder = knownOrder ++ remainingCategories;

  sortPackages = pkgs: builtins.sort (a: b: a.name < b.name) pkgs;

  renderCategory = category: let
    pkgsInCategory = grouped.${category} or [];
    sorted = sortPackages pkgsInCategory;
  in
    if builtins.length sorted == 0
    then ""
    else let
      header = "| Name | Version | Log location | Config location |";
      separator = "|------|---------|--------------|-----------------|";
      rows =
        map (
          pkg: "| ${pkg.name} | ${pkg.version} | ${pkg.logLocation} | ${pkg.configLocation} |"
        )
        sorted;
    in
      builtins.concatStringsSep "\n" (
        [
          "### ${category}"
          ""
          header
          separator
        ]
        ++ rows
      );

  renderedCategories = builtins.filter (s: s != "") (map renderCategory categoryOrder);

  markdown = builtins.concatStringsSep "\n\n" (["# ${hostName}"] ++ renderedCategories) + "\n";
in
  pkgs.writeTextDir "README.md" markdown
