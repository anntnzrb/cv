{ pkgs, ... }:
pkgs.nixfmt-tree.override {
  settings = {
    formatter = {
      typstyle = {
        command = "${pkgs.typstyle}/bin/typstyle";
        options = [ "-i" ];
        includes = [ "*.typ" ];
      };
      shfmt = {
        command = "${pkgs.shfmt}/bin/shfmt";
        options = [ "-w" ];
        includes = [
          "*.sh"
          "bin/*"
        ];
      };
    };
  };
  runtimeInputs = [
    pkgs.typstyle
    pkgs.shfmt
  ];
}
