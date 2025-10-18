{
  description = "x44anie nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, ... }:
    let
      system = "aarch64-darwin";

      configuration = { config, pkgs, ... }:

        let
          env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            pathsToLink = "/Applications";
          };
        in {

          nixpkgs.config.allowUnfree = true;

          environment.systemPackages = with pkgs; [
            spicetify-cli
            nodejs_24
            colima
            docker
            neovim
            pnpm
            btop
            eza
          ];

          environment.variables = {
            DOCKER_HOST = "/Users/x44annie/.colima/docker/docker.sock";
          };

          system.activationScripts.applications.text = pkgs.lib.mkForce ''
            echo "setting up /Applications..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            while read -r src; do
              app_name=$(basename "$src")
              echo "copying $src" >&2
              ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
          '';

          programs.zsh.enable = true; 

          programs.zsh.shellInit = ''
            export PNPM_HOME="/Users/x44annie/Library/pnpm"
            case ":$PATH:" in 
              *":$PNPM_HOME:"*) ;; 
              *) export PATH="$PNPM_HOME:$PATH" ;;
            ecas
          '';

          nix.settings.experimental-features = "nix-command flakes";

          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = system;
        };
    in {
      darwinConfigurations."main" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [ configuration ];
      };
    };
}

