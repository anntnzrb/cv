{
  inputs,
  ...
}:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = _: {
    treefmt.config = {
      projectRootFile = ".git/config";
      programs = {
        actionlint.enable = true;
        just.enable = true;
        nixfmt.enable = true;
        prettier.enable = true;
        typstfmt.enable = true;

        deadnix = {
          enable = true;
          no-underscore = true;
        };

        statix = {
          enable = true;
          disabled-lints = [ "repeated_keys" ];
        };
      };
    };
  };
}
