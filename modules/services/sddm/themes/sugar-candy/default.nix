{
	stdenvNoCC,
	fetchFromGitLab,
	qtbase,
	qtsvg,
	qtquickcontrols2,
	qtgraphicaleffects,
	wrapQtAppsHook
}: 
	stdenvNoCC.mkDerivation rec {
    pname = "sddm-sugar-candy";
    version = "2b72ef6c6f720fe0ffde5ea5c7c48152e02f6c4f";
    dontBuild = true;

    src = fetchFromGitLab {
			domain = "framagit.org";
      owner = "MarianArlt";
      repo = "${pname}";
      rev = "${version}";
      sha256 = "sha256-XggFVsEXLYklrfy1ElkIp9fkTw4wvXbyVkaVCZq4ZLU=";
    };

	 	nativeBuildInputs = [
			wrapQtAppsHook
		];

		propagatedUserEnvPkgs = [
			qtbase
			qtsvg
			qtquickcontrols2
			qtgraphicaleffects
		];

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/${pname}
    '';
  }	
