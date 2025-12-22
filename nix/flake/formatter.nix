{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.writeShellApplication {
        name = "fmt";
        runtimeInputs = [
          pkgs.typstyle
          pkgs.shfmt
          pkgs.findutils
        ];
        text = ''
          find . -name "*.typ" -type f -exec typstyle --inplace {} +
          shfmt -i 2 -p -bn -w bin/cv
        '';
      };
    };
}
