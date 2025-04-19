{
  description = "Install atcoder-cli without local package.json";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        atcoder-cli = pkgs.buildNpmPackage rec {
          pname = "atcoder-cli";
          version = "2.2.0";

          src = pkgs.fetchFromGitHub {
            owner = "Tatamo";
            repo = "atcoder-cli";
            rev = "v${version}";
            sha256 = "sha256-7pbCTgWt+khKVyMV03HanvuOX2uAC0PL9OLmqly7IWE=";
          };
          makeCacheWritable = false;

          npmDepsHash = "sha256-ufG7Fq5D2SOzUp8KYRYUB5tYJYoADuhK+2zDfG0a3ks=";

          npmPackFlags = ["--ignore-scripts"];
          NODE_OPTIONS = "--openssl-legacy-provider";
        };
        # py.nixからのオーバーレイを読み込む
        pythonOverlay = import ./python-overlay.nix {
          inherit (pkgs) fetchurl fetchgit fetchhg;
          inherit pkgs;
        };

        pythonWithOverlay = pkgs.python3.override {
          packageOverrides = pythonOverlay;
        };

        pythonEnv = pythonWithOverlay.withPackages (ps: [
          ps.aclogin
        ]);
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
          ];
          packages = with pkgs; [
            atcoder-cli
            online-judge-tools
            ac-library
            cppcheck
            bear
          ];
        };
      });
}
