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

  # This tells XMonad to use this specific environment for recompilation
  buildInputs = [
    (pkgs.ghc.withPackages (p: [
      p.xmonad
      p.xmonad-contrib
      p.network-info
    ]))
  ];

}

