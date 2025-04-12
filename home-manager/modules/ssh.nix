{
  lib,
  pkgs,
  ...
}: {
  # cloudflared is required for tunneling through Cloudflare Zero Trust
  home.packages = [pkgs.cloudflared];

  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    compression = true;
    #startAgent = true;
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "60m";
    matchBlocks = {
      # Proxmox Virtual Environment
      andromeda = {
        user = "root";
        hostname = "138.201.57.80";
        port = 2222;
      };
      git = {
        hostname = "git.airshade.net";
        user = "gitlab";
        identitiesOnly = true;
        #identityFile = "~/.ssh/id_ed25519_sk";
      };
      mercury = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.10";
        proxyJump = "andromeda";
        user = "root";
        #identityFile = "~/.ssh/proxmox";
      };
      silicon = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.20";
        proxyJump = "andromeda";
        user = "root";
        #identityFile = "~/.ssh/proxmox";
      };
      voyager-01 = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.21";
        proxyJump = "andromeda";
        user = "root";
        #identityFile = "~/.ssh/proxmox";
      };
    };
  };
}
