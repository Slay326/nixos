{
  pkgs,
  inputs,
  ...
}: let
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

  home.packages = with pkgs; [
    # Compilers
    dotnet-combined
    gcc

    volta
    # Rust
    rustup

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
