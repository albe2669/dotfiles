if status is-interactive
    # Commands to run in interactive sessions can go here
end

set GDK_SCALE 2
set GDK_DPI_SCALE 0.5
set QT_AUTO_SCREEN_SCALE_FACTOR 1

# Go stuff
set -x GOPATH $HOME/.local/go

# Path
fish_add_path /usr/local/go/bin
fish_add_path /usr/local/texlive/2022/bin/x86_64-linux

fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/go/bin
fish_add_path $HOME/.cargo/bin

fish_add_path $HOME/Documents/Installs/nvim
fish_add_path $HOME/Documents/Installs/lazygit
fish_add_path $HOME/Documents/Installs/kubectl
fish_add_path $HOME/Documents/Installs/kustomize
fish_add_path $HOME/Documents/Installs/kind
fish_add_path $HOME/Documents/Installs/dagger/bin
fish_add_path $HOME/Documents/Installs/rust_analyzer
fish_add_path $HOME/Documents/Installs/zotero
fish_add_path $HOME/Documents/Installs/google-cloud-sdk/bin
fish_add_path $HOME/Documents/Installs/lsp/lua/bin

fish_add_path $HOME/Documents/Installs/zotero

jump shell fish | source
