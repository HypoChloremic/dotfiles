# Instructions

## neovim installation on nixos system

To download the latest neovim version on nixos, we needed flakes

We added the following
/etc/nixos/configuration.nix
```nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

subsequently we ran the following command:
```sh
> nix profile install nixpkgs#neovim
```
