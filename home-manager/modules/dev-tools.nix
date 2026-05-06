{
  lib,
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  dotnet-combined = (with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_10_0
      sdk_9_0
    ])
    .overrideAttrs (finalAttrs: previousAttrs: {
    # This is needed to install workload in $HOME
    # https://discourse.nixos.org/t/dotnet-maui-workload/20370/12

    postBuild =
      (previousAttrs.postBuild or '''')
      + ''
        for i in $out/sdk/*
        do
          i=$(basename $i)
          length=$(printf "%s" "$i" | wc -c)
          substring=$(printf "%s" "$i" | cut -c 1-$(expr $length - 2))
          i="$substring""00"
          mkdir -p $out/metadata/workloads/''${i/-*}
          touch $out/metadata/workloads/''${i/-*}/userlocal
        done
      '';
  });
in {
  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}/share/dotnet";
    DOTNET_MULTILEVEL_LOOKUP = "0";
    MSBUILDTERMINALLOGGER = "auto";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
    # Volta
    VOLTA_HOME = "$HOME/.volta";
  };

  home.sessionPath = [
    "$HOME/.volta/bin"
  ];

  home.activation.repairVoltaShims = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Volta shims are absolute symlinks into the Nix store and can break after rebuild/GC.
    # Refresh them directly here instead of calling `volta setup`, which tries to edit shell
    # profiles and fails in the non-interactive Home Manager activation environment.
    export VOLTA_HOME="$HOME/.volta"
    shim="${pkgs.volta}/bin/volta-shim"

    if [ -d "$VOLTA_HOME/bin" ]; then
      for bin in "$VOLTA_HOME"/bin/*; do
        [ -e "$bin" ] || continue
        ln -sfn "$shim" "$bin"
      done
    fi
  '';

  home.packages = with pkgs; [
    # Compilers
    dotnet-combined
    gcc
    cmake
    gnumake
    volta
    # Rust
    rustup
    inputs.codex-cli-nix.packages.${system}.default
    inputs.claude-code-nix.packages.${system}.default
    # Misc
    hyperfine
    glow
    tokei
    difftastic
    terraform
    xclip
  ];

  programs.zsh.initContent = ''
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
  '';
}
