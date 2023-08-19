{ pkgs, ... }:

{
  home.packages = with pkgs; [
    go
    nodejs-16_x
    
    # Rust
    cargo
    rustc
    openssl # openssl-sys
    pkg-config # openssl-sys
  ];
}
