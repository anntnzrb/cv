{
  inputs,
  ...
}:
{
  perSystem =
    {
      self',
      pkgs,
      system,
      ...
    }:
    {
      checks.pre-commit = inputs.pre-commit-hooks.lib.${system}.run {
        src = inputs.self;

        hooks = {
          flake-checker.enable = true;
          actionlint.enable = true;
          typstfmt.enable = true;

          deadnix = {
            enable = true;
            settings = {
              edit = true;
              noUnderscore = true;
            };
          };

          statix =
            let
              cfg = (pkgs.formats.toml { }).generate "statix.toml" { disabled = disabled-lints; };
              disabled-lints = [ "repeated_keys" ];
            in
            {
              enable = true;
              package = pkgs.writeShellApplication {
                name = "statix";
                runtimeInputs = [ pkgs.statix ];
                text = ''
                  shift
                  exec statix check --config ${cfg} "$@"
                '';
              };
            };
        };
      };

      checks.default = self'.checks.pre-commit;
    };
}
