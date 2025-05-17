{
  config,
  pkgs,
  lib,
  ...
}: let
  args = [
    "--enable-features=UseOzonePlatform"
    "--ozone-platform=wayland"
    "--ignore-gpu-blocklist"
    "--enable-zero-copy"
    "--enable-features=VaapiVideoDecodeLinuxGL"
  ];
  jetbrains-plugins = ["ideavim"];
in {
  home.username = "og326";
  home.homeDirectory = "/Users/og326";

  home.packages = with pkgs; [
    htop
    curl
    (google-chrome.override {
      commandLineArgs = args;
    })
    firefox
    (jetbrains.plugins.addPlugins jetbrains.rider jetbrains-plugins)
    (jetbrains.plugins.addPlugins jetbrains.clion jetbrains-plugins)
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate jetbrains-plugins)
    nerd-fonts.jetbrains-mono
  ];

  #home.sessionVariables = {
  #  PATH =
  #    "/opt/homebrew/bin/ssh:"
  #    #"/opt/homebrew/bin/git:"
  #    + (
  #      if builtins.getEnv "PATH" == null
  #      then ""
  #      else builtins.getEnv "PATH"
  #    );
  #};

  home.sessionVariables = {
    SSH_AUTH_SOCK = "~/.ssh/agent";
    SSH_ASKPASS = "/opt/homebrew/bin/ssh-askpass";
    SSH_ASKPASS_REQUIRE = "force";
  };

  home.sessionPath = [
    "/opt/homebrew/bin/ssh"
    "/opt/homebrew/bin/git"
  ];

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

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Sleither Reyes";
    userEmail = "sleither.reyes@gmx.de";
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      core.autocrlf = false;
      credential.helper = "libsecret";
      rerere.enabled = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "/Users/og326/.ssh/id_ed25519_sk";
    };

    difftastic.enable = true;
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave.override {
      commandLineArgs = args;
    };
    extensions = [
      # Bypass Paywalls Chrome Clean
      {
        id = "lkbebcjgcmobigpeffafkodonchffocl";
        #updateUrl = "https://gitlab.com/magnolia1234/bypass-paywalls-chrome-clean/-/raw/master/updates.xml";
      }
      # AdNauseam
      {
        id = "dkoaabhijcomjinndlgbmfnmnjnmdeeb";
        #updateUrl = "https://rednoise.org/adnauseam/updates.xml";
      }
      # Bitwarden
      {
        id = "nngceckbapebfimnlniiiahkandclblb";
      }
    ];
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        font = wezterm.font("JetBrainsMono Nerd Font"),
        font_size = 14.0,
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };

  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        userSettings = {
          "editor.fontFamily" = "JetBrainsMono Nerd Font";
        };
      };
    };
  };

  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = true;
      format = "$all";
      character = {
        success_symbol = "[](fg:#33658A)";
        error_symbol = "[](fg:#33658A bg:#8B0000)[ ! ](bg:#8B0000)[](fg:#8B0000)";
        vimcmd_symbol = "[](fg:#33658A bg:#008080)[ VIM ](bg:#008080)[](fg:#008080)";
      };
      directory = {
        read_only = " 󰌾";
        truncation_length = 3;
        truncate_to_repo = true;
        truncation_symbol = "…/";
        home_symbol = "󰋜 ";
        substitutions = {
          "Documents" = "󰈙 ";
          "Dokumente" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Musik" = " ";
          "Pictures" = " ";
          "Bilder" = " ";
        };
      };
      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#33658A";
        format = "[ $time ]($style)";
      };
      battery = {
        format = "[ $symbol$percentage ]($style)[](fg:#696969 bg:#33658A)";
        display = [
          {
            threshold = 10;
            style = "bold red bg:#696969";
          }
          {
            threshold = 30;
            style = "bold yellow bg:#696969";
          }
          {
            threshold = 80;
            style = "bg:#696969";
          }
        ];
      };

      # Packages
      aws.symbol = ''  '';
      aws.format = ''\[[$symbol($profile)(\($region\))(\[$duration\])]($style)\]'';
      aws.disabled = true;
      buf.symbol = '' '';
      bun.format = ''\[[$symbol($version)]($style)\]'';
      c.symbol = '' '';
      c.format = ''\[[$symbol($version(-$name))]($style)\]'';
      cmake.format = ''\[[$symbol($version)]($style)\]'';
      cmd_duration.format = ''\[[⏱ $duration]($style)\]'';
      cobol.format = ''\[[$symbol($version)]($style)\]'';
      conda.symbol = " ";
      conda.format = ''\[[$symbol$environment]($style)\]'';
      dart.symbol = " ";
      dart.format = ''\[[$symbol($version)]($style)\]'';
      docker_context.symbol = " ";
      docker_context.format = ''\[[$symbol$context]($style)\]'';
      elixir.symbol = " ";
      elixir.format = ''\[[$symbol($version \(OTP $otp_version\))]($style)\]'';
      elm.symbol = " ";
      elm.format = ''\[[$symbol($version)]($style)\]'';
      git_branch.symbol = " ";
      git_branch.format = ''\[[$symbol$branch]($style)\]'';
      git_status.format = ''([\[$all_status$ahead_behind\]]($style))'';
      golang.symbol = " ";
      golang.format = ''\[[$symbol($version)]($style)\]'';
      haskell.symbol = " ";
      haskell.format = ''\[[$symbol($version)]($style)\]'';
      hg_branch.symbol = " ";
      hg_branch.format = ''\[[$symbol$branch]($style)\]'';
      java.symbol = " ";
      java.format = ''\[[$symbol($version)]($style)\]'';
      julia.format = ''\[[$symbol($version)]($style)\]'';
      julia.symbol = " ";
      kotlin.format = ''\[[$symbol($version)]($style)\]'';
      lua.symbol = " ";
      lua.format = ''\[[$symbol($version)]($style)\]'';
      #memory_usage.symbol = " ";
      memory_usage.format = ''\[$symbol[$ram( | $swap)]($style)\]'';
      #nim.symbol = " ";
      nim.format = ''\[[$symbol($version)]($style)\]'';
      nix_shell.symbol = " ";
      nix_shell.format = ''\[[$symbol$state( \($name\))]($style)\]'';
      nodejs.symbol = '' '';
      nodejs.format = ''\[[$symbol($version)]($style)\]'';
      #package.symbol = " ";
      package.format = ''\[[$symbol$version]($style)\]'';
      python.symbol = " ";
      python.format = ''\[[''${symbol}''${pyenv_prefix}(''${version})(\($virtualenv\))]($style)\]'';
      rlang.symbol = "ﳒ ";
      ruby.symbol = " ";
      ruby.format = ''\[[$symbol($version)]($style)\]'';
      rust.symbol = " ";
      rust.format = ''\[[$symbol($version)]($style)\]'';
      spack.symbol = "🅢 ";
      spack.format = ''\[[$symbol$environment]($style)\]'';
      crystal.format = ''\[[$symbol($version)]($style)\]'';
      daml.format = ''\[[$symbol($version)]($style)\]'';
      deno.format = ''\[[$symbol($version)]($style)\]'';
      dotnet.format = ''\[[$symbol($version)(🎯 $tfm)]($style)\]'';
      erlang.format = ''\[[$symbol($version)]($style)\]'';
      gcloud.format = ''\[[$symbol$account(@$domain)(\($region\))]($style)\]'';
      helm.format = ''\[[$symbol($version)]($style)\]'';
      kubernetes.format = ''\[[$symbol$context( \($namespace\))]($style)\]'';
      ocaml.format = ''\[[$symbol($version)(\($switch_indicator$switch_name\))]($style)\]'';
      openstack.format = ''\[[$symbol$cloud(\($project\))]($style)\]'';
      perl.format = ''\[[$symbol($version)]($style)\]'';
      php.format = ''\[[$symbol($version)]($style)\]'';
      pulumi.format = ''\[[$symbol$stack]($style)\]'';
      purescript.format = ''\[[$symbol($version)]($style)\]'';
      raku.format = ''\[[$symbol($version-$vm_version)]($style)\]'';
      red.format = ''\[[$symbol($version)]($style)\]'';
      scala.format = ''\[[$symbol($version)]($style)\]'';
      sudo.format = ''\[[as $symbol]\]'';
      swift.format = ''\[[$symbol($version)]($style)\]'';
      terraform.format = ''\[[$symbol$workspace]($style)\]'';
      username.format = ''\[[$user]($style)\]'';
      vagrant.format = ''\[[$symbol($version)]($style)\]'';
      vlang.format = ''\[[$symbol($version)]($style)\]'';
      zig.format = ''\[[$symbol($version)]($style)\]'';
    };
  };
}
