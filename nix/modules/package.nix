{
  inputs,
  ...
}:
{
  perSystem =
    {
      self',
      pkgs,
      ...
    }:
    {
      packages = {
        default = self'.packages.cv-en;

        cv-en = pkgs.stdenvNoCC.mkDerivation {
          name = "annt-cv_en";
          version = "0.1.0";
          src = inputs.self;

          nativeBuildInputs = [ pkgs.typst ];

          buildPhase = ''
            ./bin/compile-cv.sh --src=./src --input=en/main.typ --output="annt-cv_en.pdf"
          '';

          installPhase = ''
            mkdir -p $out/docs
            cp annt-cv_en.pdf $out/docs
          '';
        };
      };
    };
}
