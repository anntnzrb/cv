_: {
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "annt-cv-devshell";
        meta.description = "annt's CV development environment";

        packages =
          with pkgs;
          [
            just
            typst
          ]
          ++ [ config.treefmt.build.wrapper ];
      };
    };
}
