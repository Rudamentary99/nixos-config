{ pkgs, flake, rosettaPkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    nodejs # Required for VSCode's webhint extension
    skhd
    yabai
    # flake.inputs.hci.packages.${pkgs.system}.hercules-ci-cli
    flake.inputs.nixpkgs-match.packages.${pkgs.system}.default

  ];

  nix = {
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    extraOptions = ''
      extra-platforms = aarch64-darwin x86_64-darwin
      experimental-features = nix-command flakes repl-flake
    '';
  };

  security.pam.enableSudoTouchIdAuth = true;

  # For home-manager to work.
  users.users.${flake.config.people.myself} = {
    name = flake.config.people.myself;
    home = "/Users/${flake.config.people.myself}";
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
