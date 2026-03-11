{
  description = "Personal flake templates";
  inputs = {
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };
  outputs =
    inputs@{ flake-parts, treefmt-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake.templates = {
        rust = {
          path = ./rust;
          description = "Rust flake with fenix";
          welcomeText = ''
            # Getting started
            - Change toolchain in flake.nix by setting the fenix variable.
              Check https://github.com/nix-community/fenix?tab=readme-ov-file#usage
              for possible values.
            - Run `direnv allow`
            - Run `cargo init`
          '';
        };
      };

      imports = [ treefmt-nix.flakeModule ];

      perSystem.treefmt.programs = {
        just.enable = true;
        nixfmt.enable = true;
      };

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    };
}
