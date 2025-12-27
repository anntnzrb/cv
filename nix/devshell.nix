{ pkgs, flake, ... }:
pkgs.mkShell {
  packages = flake.lib.devTools pkgs;
}
