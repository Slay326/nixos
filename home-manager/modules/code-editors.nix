{
  pkgs,
  inputs,
  ...
}: let
  # own nixpkgs with some updated packages
  meenzen = import inputs.nixpkgs-meenzen {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  jetbrains-plugins = ["ideavim"];
  vscodeCustomExtensionsList = [
    {
      name = "pascal";
      publisher = "alefragnani";
      version = "9.9.0";
      sha256 = "sha256-qXBSvE8HVfKOkU9l1mxiQiWguQkI8PNBDgGRKO41GSI=";
    }
    {
      name = "nix-extension-pack";
      publisher = "pinage404";
      version = "3.0.0";
      sha256 = "sha256-cWXd6AlyxBroZF+cXZzzWZbYPDuOqwCZIK67cEP5sNk=";
    }
    {
      name = "opentofu";
      publisher = "gamunu";
      version = "0.2.1";
      sha256 = "OizdHTSGuwBRuD/qPXjmna6kZWfRp9EimhcFk3ICN9I=";
    }
    {
      name = "latex-formatter";
      publisher = "nickfode";
      version = "1.0.5";
      sha256 = "JzctJW0/rCEFbNxeGh/chLE4LU/oydW3QKdAxgj64v8=";
    }
    {
      name = "vscode-typescript-next";
      publisher = "ms-vscode";
      version = "5.9.20250601";
      sha256 = "OAFZFfxww6rWMj9Rfa7XMru91otNnlI8k9ttSfqW15A=";
    }
  ];
  vscodeCustomExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace vscodeCustomExtensionsList;

  vscodeStandardExtensions = with pkgs.vscode-extensions; [
    mkhl.direnv
    editorconfig.editorconfig
    eamodio.gitlens
    hashicorp.terraform
    bbenoist.nix
    arrterian.nix-env-selector
    jnoortheen.nix-ide
    ms-azuretools.vscode-docker
    christian-kohler.npm-intellisense
    esbenp.prettier-vscode
    hashicorp.terraform
    #ms-vscode.vscode-typescript-next
    angular.ng-template
    svelte.svelte-vscode
    yzhang.markdown-all-in-one
  ];

  additionalExtensions = [];
in {
  home.packages = with pkgs; [
    # Editors
    vscode
    kdePackages.kate
    jetbrains-toolbox
    # https://nixos.wiki/wiki/Jetbrains_Tools
    (jetbrains.plugins.addPlugins jetbrains.rider jetbrains-plugins)
    (jetbrains.plugins.addPlugins jetbrains.clion jetbrains-plugins)
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate jetbrains-plugins)
  ];

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
          "application.shellEnvironmentResolutionTimeout" = 20;
        };
        extensions = vscodeStandardExtensions ++ vscodeCustomExtensions ++ additionalExtensions;
      };
    };
  };

  home.file.".ideavimrc".text = ''
    " .ideavimrc is a configuration file for IdeaVim plugin. It uses
    "   the same commands as the original .vimrc configuration.
    " You can find a list of commands here: https://jb.gg/h38q75
    " Find more examples here: https://jb.gg/share-ideavimrc

    "" -- Suggested options --
    " Show a few lines of context around the cursor. Note that this makes the
    " text scroll if you mouse-click near the start or end of the window.
    set scrolloff=5

    " Do incremental searching.
    set incsearch

    " J - Join things.
    set ideajoin

    " Case-insensitive search.
    set ignorecase smartcase

    " Don't use Ex mode, use Q for formatting.
    map Q gq

    " Use relative line numbers.
    set relativenumber number

    " --- Enable IdeaVim plugins https://jb.gg/ideavim-plugins

    " Highlight copied text
    Plug 'machakann/vim-highlightedyank'
    " Commentary plugin
    Plug 'tpope/vim-commentary'

    " Quickscope plugin (install IdeaVim-Quickscope in Settings | Plugins)
    set quickscope
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

    "" -- Map IDE actions to IdeaVim -- https://jb.gg/abva4t
    "" Map \r to the Reformat Code action
    map \r <Action>(ReformatCode)

    "" Map <leader>d to start debug
    "map <leader>d <Action>(Debug)

    "" Map \b to toggle the breakpoint on the current line
    map \b <Action>(ToggleLineBreakpoint)
  '';
}
