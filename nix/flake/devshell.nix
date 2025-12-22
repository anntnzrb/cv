{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.typst
          pkgs.typstyle
          pkgs.shfmt
          pkgs.yq-go
          pkgs.findutils
        ];
      };
    };
}
