# heaper-nix

Nix package for [Heaper](https://heaper.de) — wraps the official AppImage.

> **⚠️ Note:** This repo is not actively maintained. It was created for personal use and is provided as-is. Feel free to fork, modify, and use however you like (MIT licensed).

## Usage

### As a flake input

```nix
{
  inputs.heaper.url = "github:node-openclaw/heaper-nix";

  outputs = { nixpkgs, heaper, ... }: {
    # Option 1: overlay
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [{
        nixpkgs.overlays = [ heaper.overlays.default ];
        environment.systemPackages = [ pkgs.heaper ];
      }];
    };

    # Option 2: direct package
    # heaper.packages.x86_64-linux.default
  };
}
```

### Try it

```bash
nix run github:node-openclaw/heaper-nix
```

## Version

Currently tracking Heaper v16.16.23 (x86_64 AppImage).

## License

MIT — do whatever you want with it.
