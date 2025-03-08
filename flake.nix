{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          pkgs,
          lib,
          system,
          ...
        }:
        let
          wave = pkgs.stdenvNoCC.mkDerivation {
            pname = "test-supercollider";
            version = "0.1.0-dev";
            src = lib.cleanSource ./.;

            buildInputs = [
              pkgs.supercollider
              pkgs.libxkbcommon
            ];

            buildPhase = ''
              runHook preBuild

              #> Running phase: buildPhase
              #> terminate called after throwing an instance of 'boost::filesystem::filesystem_error'
              #>   what():  boost::filesystem::create_directories: Permission denied: "/homeless-shelter/.config"
              #> /nix/store/mwmcmzyvan2pyd1z17xv3awxjs4b8793-stdenv-linux/setup: line 1767:    42 Aborted                 (core dumped) sclang src/main.scd
              export HOME=$TMPDIR

              sclang src/init.scd

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              mkdir -p $out/share/test-supercollider
              cp output.wav $out/share/test-supercollider/output.wav

              runHook postInstall
            '';

            QT_QPA_PLATFORM = "offscreen";
          };
        in
        {
          packages = {
            inherit wave;
            default = wave;
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.mdformat.enable = true;
            programs.actionlint.enable = true;
          };

          devShells.default = pkgs.mkShell rec {
            nativeBuildInputs = [
              pkgs.nil
              pkgs.supercollider
            ];

            shellHook = ''
              export PS1="\n[nix-shell:\w]$ "
            '';
          };
        };
    };
}
