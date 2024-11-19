{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = [pkgs.git];

  shellHook = ''
    echo "Git and experimental features enabled."
    git config --global user.name "<John Doe>"
    git config --global user.email "JDoe@example.com"
    export NIX_CONFIG="experimental-features = nix-command flakes"
    echo "NIX_CONFIG=$NIX_CONFIG"
  '';
}
