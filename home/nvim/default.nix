{
  pkgs,
  config,
	lib,
  ...
}: {
  home.packages = with pkgs; [
		curl # for vimplug
    neovim
    virtualenv
    xclip
    lazygit
    tree-sitter
    stdenv.cc
  ];

	home.activation.vimplug = lib.hm.dag.entryAfter ["installPackages"] ''
		PATH="${config.home.path}/bin:$PATH"
		sh -c 'curl -fLo "''${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	'';

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
