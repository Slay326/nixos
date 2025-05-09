{lib, ...}: {
  nixpkgs = {
    config = {
      # Allow installing unfree packages
      allowUnfree = true;
      # see https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Additional Binary Cache
  nix.settings = {
    substituters = ["https://nix-community.cachix.org" "https://hyprland.cachix.org"];
    trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    trusted-users = ["root" "@wheel"];
    download-buffer-size = 20971520;
  };

  nix.extraOptions = ''
    # Make debugging easier
    log-lines = 25

    # Make sure we don't run out of disk space when building
    min-free = 128000000
    max-free = 1000000000

    # Fall back to building from source if a binary cache is not available
    fallback = true
    connect-timeout = 5
  '';

  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
