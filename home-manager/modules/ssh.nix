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
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        ForwardAgent = false;
        Compression = true;
        ServerAliveInterval = 30;
        ServerAliveCountMax = 2;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%C";
        ControlPersist = "10m";
      };
      # Proxmox Virtual Environment
      andromeda = {
        User = "root";
        HostName = "138.201.57.80";
        Port = 2222;
      };
      git = {
        HostName = "git.sleither.net";
        User = "gitlab";
        IdentitiesOnly = true;
      };
      mercury = lib.hm.dag.entryAfter ["andromeda"] {
        HostName = "10.0.0.10";
        ProxyJump = "andromeda";
        User = "root";
        IdentitiesOnly = true;
        IdentityFile = "/home/slay/.ssh/id_ed25519";
      };
      silicon = lib.hm.dag.entryAfter ["andromeda"] {
        HostName = "10.0.0.20";
        ProxyJump = "andromeda";
        User = "root";
        IdentitiesOnly = true;
        IdentityFile = "/home/slay/.ssh/id_ed25519";
      };
      voyager-01 = lib.hm.dag.entryAfter ["andromeda"] {
        HostName = "10.0.0.21";
        ProxyJump = "andromeda";
        User = "root";
        IdentitiesOnly = true;
        IdentityFile = "/home/slay/.ssh/id_ed25519";
      };
      atlas = lib.hm.dag.entryAfter ["andromeda"] {
        HostName = "10.0.0.30";
        ProxyJump = "andromeda";
        User = "root";
        IdentitiesOnly = true;
        IdentityFile = "/home/slay/.ssh/id_ed25519";
      };

      centauri = {
        HostName = "192.168.2.105";
        User = "root";
        IdentitiesOnly = true;
        IdentityFile = "/home/slay/.ssh/id_ed25519";
      };

      windows-slave = {
        HostName = "192.168.2.47";
        User = "administrator";
        IdentitiesOnly = true;
      };
    };
  };
}
