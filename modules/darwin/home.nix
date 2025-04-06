{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "og326";
  home.homeDirectory = "/Users/og326";

  home.packages = with pkgs; [
    htop
    curl

  ];

    home.sessionVariables = {
PATH = "/opt/homebrew/bin/ssh:" + (if builtins.getEnv "PATH" == null then "" else builtins.getEnv "PATH");
  };


  programs.ssh = {
    enable = true;
    compression = true;
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "60m";
    matchBlocks = {
      # Proxmox Virtual Environment Realm
      andromeda = {
        user = "root";
        hostname = "138.201.57.80";
        port = 2222;
      };
      mercury = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.10";
        proxyJump = "andromeda";
        user = "root";
      };
      silicon = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.20";
        proxyJump = "andromeda";
        user = "root";
      };
      voyager-01 = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.21";
        proxyJump = "andromeda";
        user = "root";
      };
    };
  };
}
