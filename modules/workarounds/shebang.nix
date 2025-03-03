{
  lib,
  config,
  ...
}: {
  # fix shebangs like '/bin/bash', see https://github.com/Mic92/envfs
  services.envfs = lib.mkIf config.slay.desktop.enable {
    enable = true;
  };
}
