{
  description = "XMonad build environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        # This provides everything needed to build AND link
        nativeBuildInputs = [
          (pkgs.ghc.withPackages (p: [ p.xmonad p.xmonad-contrib ]))
          pkgs.xorg.libX11
          pkgs.xorg.libXinerama
          pkgs.xorg.libXrandr
          pkgs.xorg.libXScrnSaver
          pkgs.xorg.libXext
        ];
      };

      # This satisfies the 'nix build' command
      #packages.${system}.default = pkgs.writeShellScriptBin "xmonad-recompile" ''
      #  ${pkgs.haskellPackages.ghcWithPackages (p: [ p.xmonad p.xmonad-contrib p.network-info ])}/bin/ghc --make ~/.xmonad/xmonad.hs -o ~/.xmonad/xmonad-x86_64-linux
      #'';

    };
}
