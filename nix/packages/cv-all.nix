{ pkgs, flake, ... }:
pkgs.symlinkJoin {
  name = "cv-all";
  paths = map (flake.lib.buildCV pkgs) flake.lib.languages;
}
