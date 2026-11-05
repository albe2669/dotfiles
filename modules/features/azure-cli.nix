{
  category = "Tools";
  name = "azure-cli";
  software = [
    "azure-cli"
    "kubelogin"
  ];

  homeManager = {pkgs-unstable, ...}: let
    ssh = pkgs-unstable.azure-cli-extensions.ssh;

    # azure-cli.withExtensions is incompatible with the fabric overlay: the
    # overlay must unsafeDiscardStringContext on postFixup, which strips the
    # reference to the extension dir, so it never builds and the garbage
    # collector removes it. Build the dir here and wrap az with it; the
    # wrapper keeps it in the closure.
    #
    # az appends $AZURE_EXTENSION_DIR/ssh to sys.path, so the extension and
    # all its imports must live in one site-packages dir. closePropagation:
    # oras imports jsonschema, which azure-cli's own PYTHONPATH does not
    # carry, so the extension dir must be dependency-complete.
    sshSite = pkgs-unstable.symlinkJoin {
      name = "azure-cli-ssh-extension";
      paths = [ssh] ++ pkgs-unstable.lib.closePropagation ssh.propagatedBuildInputs;
      pathsToLink = ["/lib"];
    };

    extensionDir = pkgs-unstable.linkFarm "azure-cli-extensions" [
      {
        name = "ssh";
        path = "${sshSite}/lib/python3.14/site-packages";
      }
    ];

    az = pkgs-unstable.hiPrio (
      pkgs-unstable.symlinkJoin {
        name = "az-with-ssh-extension";
        paths = [pkgs-unstable.azure-cli];
        buildInputs = [pkgs-unstable.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/az --set AZURE_EXTENSION_DIR ${extensionDir}
        '';
      }
    );
  in {
    home.packages = [
      az
      pkgs-unstable.kubelogin
    ];
  };
}
