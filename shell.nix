{ pkgs ? import <nixpkgs> {} }:

# Usage:
#   nix-shell
#   nix-shell shell.nix

pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    #ruby_3_2
    shellcheck
  ];

  #buildInputs = [
  # gtk3
  #];
}

