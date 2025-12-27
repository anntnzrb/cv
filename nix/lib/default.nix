{ flake, ... }:
let
  manifest = builtins.fromTOML (builtins.readFile (flake + "/typst.toml"));
in
{
  inherit manifest;

  languages = [
    "en"
    "es"
  ];

  devTools =
    pkgs: with pkgs; [
      typst
      typstyle
      shfmt
      yq-go
      findutils
    ];

  buildCV =
    pkgs: lang:
    pkgs.stdenvNoCC.mkDerivation {
      pname = "${manifest.package.name}-${lang}";
      inherit (manifest.package) version;
      src = flake;
      nativeBuildInputs = [ (pkgs.typst.withPackages (_: [ ])) ];
      buildPhase = ''
        typst compile --root . --input lang=${lang} src/cv.typ cv-${lang}.pdf
      '';
      installPhase = ''
        mkdir -p $out
        cp cv-${lang}.pdf $out/${manifest.package.name}-${lang}.pdf
      '';
    };

  mkCvScript =
    pkgs:
    pkgs.writeShellApplication {
      name = "cv";
      runtimeInputs = flake.lib.devTools pkgs;
      text = builtins.readFile (flake + "/bin/cv");
    };
}
