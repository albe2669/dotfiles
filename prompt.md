I want to restructure to the dendritic pattern. 

So instead of now where everything is packaged into different types of packages, like home, nix, darwin, it should be one package using flake-parts.
For example, Hyprland should not be spread out, the configuration should be in one place, in the same file.
Hosts should then be extremely easy to put together, we shouldn't have to import botht the home and nix package, but just one package that contains everything.

There should also be a function exported that allows me to add completions and environment variables to the shell, regardless of the shell. So the "shell" package should export a function that allows me to do that. If switching from fish to zsh i then only change that function.

Thoroughly research the dendritic pattern and how it can be applied to NixOS configurations. This will involve understanding the principles of the dendritic pattern, such as modularity, separation of concerns, and reusability. Then create a plan for this migration.
