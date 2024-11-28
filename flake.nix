{
  description = "Flake for nextflow language-server";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    gradle2nix.url = "github:tadfisher/gradle2nix/v2";
  };

  outputs = { self, nixpkgs, flake-utils, gradle2nix }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };

          buildGradlePackage = gradle2nix.builders.${system}.buildGradlePackage;

          nextflow-language-server =
            let
              inherit (pkgs) fetchFromGitHub jre makeWrapper;
            in
            buildGradlePackage rec {
              pname = "nextflow-language-server";
              version = "1.0.2";
              hash = "sha256-wwpm+VYySMFKQzkm/pziJwEAQ8awN/2BsiHysl9HnQU=";

              src = fetchFromGitHub {
                owner = "nextflow-io";
                repo = "language-server";
                rev = "v${version}";
                inherit hash;
              };

              nativeBuildInputs = [ makeWrapper ];

              lockFile = ./gradle.lock;

              gradleFlags = [ "build" ];

              installPhase = ''
                mkdir -p $out/share/${pname} $out/bin

                cp build/libs/language-server-all.jar $out/share/${pname}
                makeWrapper ${jre}/bin/java $out/bin/${pname} \
                  --add-flags "-jar $out/share/${pname}/language-server-all.jar"
              '';
            };
        in
        {
          # devShells = {
          #   default = pkgs.mkShell {
          #     buildInputs = [ nextflow-language-server ];
          #   };
          # };

          packages = {
            default = nextflow-language-server;
          };
        }
      );
}
