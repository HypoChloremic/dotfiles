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
> nix-shell -p xorg.xkbcomp 
> setxkbmap -I/etc/nixos/xkb/custom se-custom -print | xkbcomp -I/etc/nixos/xkb/custom - $DISPLAY
```

Note that the path is to the parent of symbols


## Flake and Home-Manager

### Setup Flake

```nix
{
  ...
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
```

#### Old

Then in /etc/nixos/ folder run
```bash
> sudo nix flake init --template github:vimjoyser/flake-starter-config
```

Will produce a flake.nix file


Next rebuild the system with the following
```bash
> sudo nixos-rebuild switch --flake /etc/nixos#default
```

### new

Assuming the nix-command and flake is up and test `nix flake --help`

#### Installing home-manager

create in the ~ directory a nixhero-manager dir
inside it run
```bash
> nix run home-manager -- init --switch .
```

This will create a flake.nix and a home.nix file 
consider the flake.nix to be a package.json of sorts.

to switch to the home-manager config we run:
```bash
> home-manager switch --flake .#alirassolie
```

Note that the alirassolie is retrieved based on the name provided by
and that the . in .#alirassolie says to use the flake.nix in the current active directory 
```
    homeConfigurations."alirassolie"
```


#### Home-manager generations

If we want to rollback home-manager to previous generations we can do the following
```bash
> home-manager generations
```
will list all of the generations
