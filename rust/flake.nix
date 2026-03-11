{
  inputs = {
    fenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/fenix";
    };
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

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          inputs',
          config,
          lib,
          pkgs,
          ...
        }:
        let
          fenix = inputs'.fenix.packages.stable;
        in
        {
          devShells.default = pkgs.mkShell {
            packages =
              let
                formatters = lib.attrValues config.treefmt.build.programs;
                rust = fenix.withComponents [
                  "cargo"
                  "clippy"
                  "rust-analyzer"
                  "rust-src"
                  "rustc"
                  "rustfmt"
                ];
                treefmt = config.treefmt.build.wrapper;
              in
              [
                pkgs.just
                rust
                treefmt
              ]
              ++ formatters;
          };

          treefmt.programs = {
            just.enable = true;
            nixfmt.enable = true;
            rustfmt = {
              enable = true;
              package = fenix.rustfmt;
            };
          };
        };

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    };
}
