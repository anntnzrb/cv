{ inputs, ... }:
let
  languages = [
    "en"
    "es"
  ];
in
{
  perSystem =
    { pkgs, self', ... }:
    let
      self = inputs.self;

      cv = pkgs.writeShellApplication {
        name = "cv";
        runtimeInputs = [
          pkgs.typst
          pkgs.typstyle
          pkgs.shfmt
          pkgs.yq-go
          pkgs.findutils
        ];
        text = builtins.readFile (self + "/bin/cv");
      };

      buildCV =
        lang:
        pkgs.stdenvNoCC.mkDerivation {
          pname = "cv-${lang}";
          version = "1.0.0";
          src = self;
          nativeBuildInputs = [ pkgs.typst ];
          buildPhase = ''
            typst compile --root . --input lang=${lang} src/cv.typ cv-${lang}.pdf
          '';
          installPhase = ''
            mkdir -p $out
            cp cv-${lang}.pdf $out/jago-cv-${lang}.pdf
          '';
        };
    in
    {
      packages = {
        inherit cv;
        default = cv;
        cv-en = buildCV "en";
        cv-es = buildCV "es";
        cv-all = pkgs.symlinkJoin {
          name = "cv-all";
          paths = map buildCV languages;
        };
      };

      apps.default = {
        type = "app";
        program = "${self'.packages.cv}/bin/cv";
      };
    };
}
