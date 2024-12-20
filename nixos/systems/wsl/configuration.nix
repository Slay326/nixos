# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.nixos = import "${inputs.self}/home-manager";
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };

      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
    }
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
    usbip.enable = true;
    usbip.autoAttach = ["2-3"];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.docker.enable = true;

  networking = {
    hostName = "wsl";
  };

  boot.kernelModules = [
    "vhci-hcd"
    "usbip-host"
  ];

  environment.systemPackages = with pkgs; [
    linuxPackages.usbip
    sudo
    kmod
    usbutils
    neovim
    fastfetch
    wget
    nmap
    git
    bash
    husky
    curl
    openssh
    (dotnetCorePackages.combinePackages [
      dotnetCorePackages.sdk_9_0
      dotnetCorePackages.sdk_8_0
    ])
    dotnetPackages.Nuget
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  programs.nix-ld.enable = true;
  systemd.tmpfiles.rules = [
    "L! ~/.ssh/ssh-agent.sock - - - - /mnt/c/Users/reyess/AppData/Local/ssh-agent/ssh-agent.sock"
  ];

  services.pcscd.enable = true;
  services.udev = {
    enable = true;
    packages = [pkgs.yubikey-personalization];
  };

  systemd.services.wslConfig = {
    description = "Configure WSL settings";

    # Die Datei /etc/wsl.conf wird durch diesen Service verwaltet
    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/echo '[wsl2]\nusbip=true\n' > /etc/wsl.conf";
      Restart = "no";
    };
  };
  environment.variables.SSH_AUTH_SOCK = "/home/nixos/.ssh/ssh-agent.sock";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
