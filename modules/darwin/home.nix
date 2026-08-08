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
in {
  home.username = "og326";
  home.homeDirectory = "/Users/og326";

  home.packages = with pkgs; [
    htop
    btop
    curl
    firefox
    jetbrains.clion
    jetbrains.idea
    jetbrains.rider
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/Users/og326/.ssh/agent.sock";
    SSH_ASKPASS = "/opt/homebrew/bin/ssh-askpass";
    SSH_ASKPASS_REQUIRE = "prefer";
    STARSHIP_CONFIG = "${config.xdg.configHome}/starship.toml";
    STARSHIP_LOG = "error";
    NIX_SHELL_PRESERVE_PROMPT = "1";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        IdentityAgent = "/Users/og326/.ssh/agent.sock";
      };
      #compression = true;
      #controlMaster = "auto";
      #controlPersist = "60m";
      github = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
        IdentitiesOnly = true;
        ControlMaster = "no";
        ControlPath = "none";
        ControlPersist = "no";
      };
      "git.sleither.net" = {
        HostName = "git.sleither.net";
        User = "gitlab";
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
        IdentitiesOnly = true;
        IdentityAgent = "/Users/og326/.ssh/agent.sock";
        AddKeysToAgent = "yes";
      };
      # Proxmox Virtual Environment Realm
      andromeda = {
        User = "root";
        HostName = "138.201.57.80";
        Port = 2222;
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
      };
      mercury = lib.hm.dag.entryAfter ["andromeda"] {
        HostName = "10.0.0.10";
        ProxyJump = "andromeda";
        User = "root";
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
      };
      silicon = lib.hm.dag.entryAfter ["andromeda"] {
        HostName = "10.0.0.20";
        ProxyJump = "andromeda";
        User = "root";
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
      };
      voyager-01 = lib.hm.dag.entryAfter ["andromeda"] {
        HostName = "10.0.0.21";
        ProxyJump = "andromeda";
        User = "root";
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
      };
      atlas = lib.hm.dag.entryAfter ["andromeda"] {
        HostName = "10.0.0.30";
        ProxyJump = "andromeda";
        User = "root";
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
      };
      phoenix = lib.hm.dag.entryAfter ["andromeda"] {
        HostName = "10.0.0.31";
        ProxyJump = "andromeda";
        User = "root";
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
      };
      quartz-win = {
        User = "sleit";
        HostName = "192.168.2.35";
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
      };
      quartz-nix = {
        User = "slay";
        HostName = "192.168.2.35";
        IdentityFile = "/Users/og326/.ssh/id_ed25519_touchid";
      };
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
    signing.format = "ssh";
    settings = {
      user = {
        name = "Sleither Reyes";
        email = "sleither.reyes@gmx.de";
        signingkey = "/Users/og326/.ssh/id_ed25519_touchid.pub";
      };
      init.defaultBranch = "master";
      credential.helper = "osxkeychain";
      rerere.enabled = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      core = {
        autocrlf = "input";
        eol = "lf";
        safecrlf = "warn";
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
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
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  home.file.".wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.xdg.configHome}/wezterm/wezterm.lua";

  programs.zsh = {
    enable = true;
    initContent = builtins.readFile ./.zshrc;
    profileExtra = builtins.readFile ./.zprofile-onyx;
  };

  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        userSettings = {
          "editor.fontFamily" = "JetBrainsMono Nerd Font";
          "git.confirmSync" = false;
          "git.enableCommitSigning" = true;
          "explorer.confirmDragAndDrop" = false;
          "terminal.integrated.enableMultiLinePasteWarning" = "never";
          "terminal.integrated.defaultProfile.osx" = "zsh";
          "terminal.integrated.profiles.osx" = {
            "zsh" = {
              "path" = "${pkgs.zsh}/bin/zsh";
              "args" = ["-l"];
            };
          };
          "application.shellEnvironmentResolutionTimeout" = 35;
          "latex-workshop.pdflatex.executable" = "/Library/TeX/Distributions/Programs/texbin/pdflatex";
          "latex-workshop.latexmk.executable" = "/Library/TeX/Distributions/Programs/texbin/latexmk";

          "latex-workshop.latex.tools" = [
            {
              name = "latexmk";
              command = "/Library/TeX/Distributions/Programs/texbin/latexmk";
              args = [
                "-pdf"
                "-interaction=nonstopmode"
                "-synctex=1"
                "-file-line-error"
                "-outdir=%OUTDIR%"
                "%DOC%"
              ];
              env = {};
            }
            {
              name = "latexmk-shellescape";
              command = "/Library/TeX/Distributions/Programs/texbin/latexmk";
              args = [
                "-pdf"
                "-interaction=nonstopmode"
                "-synctex=1"
                "-shell-escape"
                "-file-line-error"
                "-outdir=%OUTDIR%"
                "%DOC%"
              ];
              env = {};
            }
            {
              name = "pdflatex";
              command = "/Library/TeX/Distributions/Programs/texbin/pdflatex";
              args = [
                "-interaction=nonstopmode"
                "-synctex=1"
                "-file-line-error"
                "%DOC%"
              ];
              env = {};
            }
            {
              name = "xelatex";
              command = "/Library/TeX/Distributions/Programs/texbin/xelatex";
              args = [
                "-interaction=nonstopmode"
                "-synctex=1"
                "-file-line-error"
                "%DOC%"
              ];
              env = {};
            }
            {
              name = "bibtex";
              command = "/Library/TeX/Distributions/Programs/texbin/bibtex";
              args = ["%DOCFILE%"];
              env = {};
            }
          ];
          "tidalcycles.bootTidalPath" = "/Users/og326/reyshift/server options.scd";

          "latex-workshop.latex.recipes" = [
            {
              name = "latexmk 🔃";
              tools = ["latexmk"];
            }
            {
              name = "latexmk + shell-escape";
              tools = ["latexmk-shellescape"];
            }
            {
              name = "pdfLaTeX";
              tools = ["pdflatex"];
            }
            {
              name = "pdflatex ➞ bibtex ➞ pdflatex`×2";
              tools = ["pdflatex" "bibtex" "pdflatex" "pdflatex"];
            }
            {
              name = "xelatex";
              tools = ["xelatex"];
            }
            {
              name = "xelatex ➞ bibtex ➞ xelatex`×2";
              tools = ["xelatex" "bibtex" "xelatex" "xelatex"];
            }
          ];

          "latex-workshop.latex.outDir" = "%DIR%/build";
          "latex-workshop.view.pdf.viewer" = "tab";
          "[latex]" = {
            "editor.formatOnPaste" = false;
            "editor.suggestSelection" = "recentlyUsedByPrefix";
          };
          "github.copilot.enable" = {
            "*" = false;
          };
          "discord.idleTimeout" = 1200;
        };
      };
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  xdg.configFile."starship.toml".source = ./starship.toml;
}
