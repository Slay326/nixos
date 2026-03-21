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
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        forwardAgent = false;
        compression = true;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "60m";
      };
      # Proxmox Virtual Environment
      andromeda = {
        user = "root";
        hostname = "138.201.57.80";
        port = 2222;
      };
      git = {
        hostname = "git.sleither.net";
        user = "gitlab";
        identitiesOnly = true;
      };
      mercury = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.10";
        proxyJump = "andromeda";
        user = "root";
        identitiesOnly = true;
        identityFile = "/home/slay/.ssh/id_ed25519";
      };
      silicon = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.20";
        proxyJump = "andromeda";
        user = "root";
        identitiesOnly = true;
        identityFile = "/home/slay/.ssh/id_ed25519";
      };
      voyager-01 = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.21";
        proxyJump = "andromeda";
        user = "root";
        identitiesOnly = true;
        identityFile = "/home/slay/.ssh/id_ed25519";
      };
      atlas = lib.hm.dag.entryAfter ["andromeda"] {
        hostname = "10.0.0.30";
        proxyJump = "andromeda";
        user = "root";
        identitiesOnly = true;
        identityFile = "/home/slay/.ssh/id_ed25519";
      };

      centauri = {
        hostname = "192.168.2.105";
        user = "root";
        identitiesOnly = true;
        identityFile = "/home/slay/.ssh/id_ed25519";
      };

      windows-slave = {
        hostname = "192.168.2.47";
        user = "administrator";
        identitiesOnly = true;
      };
    };
  };
}
