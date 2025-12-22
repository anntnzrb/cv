{ inputs, ... }:
{
  perSystem =
    { pkgs, self', ... }:
    let
      self = inputs.self;
    in
    {
      checks = {
        format = pkgs.stdenvNoCC.mkDerivation {
          name = "format-check";
          src = self;
          nativeBuildInputs = [
            pkgs.typstyle
            pkgs.shfmt
            pkgs.findutils
          ];
          buildPhase = ''
            find . -name "*.typ" -type f -exec typstyle --check {} +
            shfmt -d -i 2 -p -bn bin/cv
          '';
          installPhase = "touch $out";
        };

        build = self'.packages.cv-all;
      };
    };
}
