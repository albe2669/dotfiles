{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      github.copilot
      vscodevim.vim
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
    ];
  };
}
