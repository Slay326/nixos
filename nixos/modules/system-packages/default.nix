{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    nano
    wget
    curl
    htop
    ncdu
    duf
    git
    dnsutils
  ];
}
