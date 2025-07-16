{
  pkgs,
  inputs,
  ...
}: let
  # plugins are currently broken, see https://github.com/nixos/nixpkgs/issues/400317
  #plugins = ["github-copilot" "ideavim"];
  meenzen = import inputs.nixpkgs-meenzen {
    system = pkgs.system;
    config.allowUnfree = true;
  };
  plugins = [];

  # https://nixos.wiki/wiki/Jetbrains_Tools
  mkIde = package:
    if plugins != []
    then (pkgs.jetbrains.plugins.addPlugins package plugins)
    else package;
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
  home.packages = [
    # Editors
    pkgs.vscode
    pkgs.kdePackages.kate

    #pkgs.jetbrains-toolbox

    (mkIde pkgs.jetbrains.rider)
    (mkIde pkgs.jetbrains.clion)
    (mkIde pkgs.jetbrains.idea-ultimate)
  ];

  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        userSettings = {
          "application.shellEnvironmentResolutionTimeout" = 20;
          "chat.editor.fontFamily" = "JetBrainsMono Nerd Font";
          "chat.editor.fontSize" = 16.0;
          "debug.console.fontFamily" = "JetBrainsMono Nerd Font";
          "debug.console.fontSize" = 16.0;
          "editor.fontFamily" = "JetBrainsMono Nerd Font";
          "editor.fontSize" = 16.0;
          "editor.inlayHints.fontFamily" = "JetBrainsMono Nerd Font";
          "editor.inlineSuggest.fontFamily" = "JetBrainsMono Nerd Font";
          "editor.minimap.sectionHeaderFontSize" = 10.285714285714286;
          "explorer.confirmDragAndDrop" = false;
          "git.confirmSync" = false;
          "git.enableCommitSigning" = true;
          "markdown.preview.fontFamily" = "Noto Sans";
          "markdown.preview.fontSize" = 16.0;
          "scm.inputFontFamily" = "JetBrainsMono Nerd Font";
          "scm.inputFontSize" = 14.857142857142858;
          "screencastMode.fontSize" = 64.0;
          "terminal.integrated.enableMultiLinePasteWarning" = "never";
          "terminal.integrated.fontSize" = 16.0;
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
