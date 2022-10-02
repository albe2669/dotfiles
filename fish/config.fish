if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Path
fish_add_path /usr/local/go/bin
fish_add_path /usr/local/texlive/2022/bin/x86_64-linux

fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

fish_add_path $HOME/Documents/Installs/nvim
fish_add_path $HOME/Documents/Installs/lazygit
fish_add_path $HOME/Documents/Installs/kubectl
fish_add_path $HOME/Documents/Installs/dagger/bin
fish_add_path $HOME/Documents/Installs/google-cloud-sdk/bin
fish_add_path $HOME/Documents/Installs/lsp/lua/bin
