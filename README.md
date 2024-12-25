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

## Customizing keys on nixos

nixos uses services xkb for keyboard layout configs.

Say we wish to modify altgr + 1 on swedish nodeadkeys layout to outut /
we will do the following:

create
```sh
> mkdir -p /etc/nixos/xkb/custom/symbols/
> vim /etc/nixos/xkb/custom/symbols/se-custom
```
note that se-custom is a file.


```
xkb_symbols "se-custom" 
{
  include "se(nodeadkeys)"
  key <AE01> { [ 1, exclam, slash, NoSymbol ] };
};
```
note that the xkb_symbols name matches the file name


then in the /etc/nixos/configuration.nix we will define:
```nix
# Enable the X11 windowing system.
services.xserver.enable = true;

# Enable the Cinnamon Desktop Environment.
services.xserver.displayManager.lightdm.enable = true;
services.xserver.desktopManager.cinnamon.enable = true;

# Configure keymap in X11
services.xserver = {
  layout = "se";
  xkbVariant = "";
  xkb = {
    extraLayouts = {
      se-custom = {
    description = "Swedish custom";
    languages = [ "se" ];
    symbolsFile = /etc/nixos/xkb/custom/symbols/se-custom;
  };
    };
  };
};
```

Note how we define the path to the se-custom symbols file without quotes. 
We also have not defined the xkbVariant


### To apply the changes

Seemingly to apply the changes we need to run setxkbmap

```sh
> setxkbmap -I/etc/nixos/xkb/custom se-custom -print
```

Note that the path is to the parent of symbols
