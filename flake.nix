{
  description = "Multilingual CV/resume generator";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-25.05/nixexprs.tar.xz";
    flake-parts.url = "github:hercules-ci/flake-parts/main";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      imports =
        let
          modDir = ./nix/flake;
        in
        with builtins;
        map (mod: "${modDir}/${mod}") (attrNames (readDir modDir));
    };
}
