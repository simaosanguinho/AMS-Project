{
  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # pre-commit-hooks-nix = {
    #   url = "github:cachix/pre-commit-hooks.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.nixpkgs-stable.follows = "nixpkgs";

    # };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        # inputs.pre-commit-hooks-nix.flakeModule
        # inputs.devenv.flakeModule
        inputs.treefmt-nix.flakeModule

      ];
      flake = {
        # Put your original flake attributes here.
      };
      #systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        # ...
      ];
      # perSystem = { config, self', inputs', pkgs, system, ... }: {
      perSystem = { pkgs, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        # packages.default = pkgs.hello;
        devShells.default = pkgs.mkShell {
          #Add executable packages to the nix-shell environment.
          packages = with pkgs; [
              archi
          ];

          # Add build dependencies of the listed derivations to the nix-shell environment.
          # inputsFrom = [ pkgs.hello pkgs.gnutar ];

         # Bash statements that are executed by nix-shell.
          shellHook = ''
            export DEBUG=1
          '';

        };
        # pre-commit = {
        #   check.enable = true;
        #   settings.hooks = {
        #     # shellcheck.enable = true;
        #     deadnix.enable = true;
        #     statix.enable = true;
        #     markdownlint.enable = false;
        #   };
        # };
        treefmt.projectRootFile = ./flake.nix;
        treefmt.programs = {
          # nixpkgs-fmt.enable = true;
          # yamlfmt.enable = true;
          # # shellcheck.enable = true;
          # shfmt.enable = true;
          # mdformat.enable = true;

        };
      };
    };
}
