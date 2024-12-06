{config, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
    };

    extraOptions = ''
      # Make debugging easier
      log-lines = 25

      # Fall back to building from source if a binary cache is not available
      fallback = true
      connect-timeout = 5
    '';
  };
}
