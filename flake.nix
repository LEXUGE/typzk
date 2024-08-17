{
  description = "Typst-based Zettelkasten Solution";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    typst2nix = {
      url = "github:LEXUGE/typst2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, utils, pre-commit-hooks, typst2nix }:
    with utils.lib;
    with nixpkgs.lib;
    with typst2nix.helpers;
    {
      overlays.default =
        (final: prev: {
          typst2nix.registery = (prev.typst2nix.registery or { }) // {
            typzk.zkgraph."0.1.0" = bundleTypstPkg
              {
                pkgs = final;
                path = ./.;
                namespace = "typzk";
              };
          };
        }
        );
    } //
    eachSystem defaultSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default typst2nix.overlays.default ];
        };
      in
      rec {
        # nix develop
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          nativeBuildInputs = with pkgs; [ (mkWrappedTypst pkgs ./.) typstfmt ];
        };

        packages = {
          manual = (buildTypstDoc {
            inherit pkgs;
            src = ./.;
            path = "./manual.typ";
            version = "git";
            pname = "zkgraph-manual";
          });
        };

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;

              shellcheck.enable = true;
              shfmt.enable = true;

              # typstfmt = mkForce {
              #   enable = true;
              #   name = "Typst Format";
              #   # Official registery has wrong executable path.
              #   entry = "${pkgs.typstfmt}/bin/typstfmt";
              #   files = "\\.(typ)$";
              # };
            };
          };
        } // packages;
      });
}
