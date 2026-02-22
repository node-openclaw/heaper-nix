{
  description = "Heaper - Nix package for the Heaper AppImage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.callPackage ./package.nix {};
      heaper = pkgs.callPackage ./package.nix {};
    });

    overlays.default = _final: prev: {
      heaper = prev.callPackage ./package.nix {};
    };
  };
}
