{pkgs-unstable, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    profiles.default.extensions = with pkgs-unstable.vscode-extensions; [
      github.copilot
      vscodevim.vim
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      golang.go
      ms-azuretools.vscode-docker
    ];
  };
}
