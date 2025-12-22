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
      manifest = builtins.fromTOML (builtins.readFile (self + "/typst.toml"));

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
          pname = "${manifest.package.name}-${lang}";
          inherit (manifest.package) version;
          src = self;
          nativeBuildInputs = [
            (pkgs.typst.withPackages (p: with p; [
              # Add Typst Universe packages here as needed
            ]))
          ];
          buildPhase = ''
            typst compile --root . --input lang=${lang} src/cv.typ cv-${lang}.pdf
          '';
          installPhase = ''
            mkdir -p $out
            cp cv-${lang}.pdf $out/${manifest.package.name}-${lang}.pdf
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
