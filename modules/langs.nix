{ pkgs, ... }:

{
  home.packages = with pkgs; [
    go
    nodejs-16_x
    
    # Rust
    cargo
    rustc
  ];
}
