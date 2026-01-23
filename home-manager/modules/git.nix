{
  config,
  lib,
  pkgs,
  osConfig ? {},
  ...
}: let
  inherit (lib) attrByPath mkDefault mkOption optionalAttrs types;

  # Resolve username from NixOS (osConfig) first, then HM. Fail fast if missing.
  osUsername = attrByPath ["slay" "username"] "" osConfig;
  hmUsername = config.home.username or "";
  username =
    if osUsername != ""
    then osUsername
    else if hmUsername != ""
    then hmUsername
    else throw "slay.git: Unable to resolve username. Set slay.username in NixOS or home.username in Home Manager.";

  osUser = attrByPath ["slay" "users" username] null osConfig;

  # Minimal fallback for HM-only usage when slay.users isn't available.
  fallbackUser = {
    username =
      if hmUsername != ""
      then hmUsername
      else username;
    fullName =
      if hmUsername != ""
      then hmUsername
      else username;
    email = "";
    home = config.home.homeDirectory;
  };

  activeUser =
    if osUser != null
    then osUser
    else fallbackUser;

  userName =
    if (activeUser ? fullName) && (activeUser.fullName or "") != ""
    then activeUser.fullName
    else if (activeUser ? username) && (activeUser.username or "") != ""
    then activeUser.username
    else throw "slay.git: Unable to resolve git userName. Set slay.users.${username}.fullName or programs.git.userName.";

  derivedEmail =
    if (activeUser ? email) && (activeUser.email or "") != ""
    then activeUser.email
    else null;

  # Opt-in SSH commit signing; override per host via slay.git.signing.enable.
  signingFromOs = attrByPath ["slay" "git" "signing" "enable"] false osConfig;
  signingEnabled = config.slay.git.signing.enable;
  signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";

  gitConfig =
    {
      enable = true;
      package = pkgs.gitFull;

      userName = mkDefault userName;
      lfs.enable = true;

      extraConfig =
        {
          init.defaultBranch = "main";
          core.autocrlf = false;
          credential.helper = "libsecret";
          rerere.enabled = true;
        }
        // optionalAttrs signingEnabled {
          commit.gpgsign = true;
          gpg.format = "ssh";
          user.signingkey = signingKey;
        };
    }
    // optionalAttrs (derivedEmail != null) {
      userEmail = mkDefault derivedEmail;
    };

  isNonEmpty = value: value != null && value != "";
in {
  options.slay.git.signing.enable = mkOption {
    type = types.bool;
    default = signingFromOs;
    description = "Enable SSH commit signing in git. Set slay.git.signing.enable = true per host to opt in.";
  };

  config = {
    programs.git = gitConfig;

    assertions = [
      {
        assertion = isNonEmpty config.programs.git.userName;
        message = "slay.git: Git userName is empty. Set slay.users.${username}.fullName/username or programs.git.userName.";
      }
      {
        assertion = isNonEmpty config.programs.git.userEmail;
        message = "slay.git: Git userEmail is empty. Set slay.users.${username}.email or programs.git.userEmail.";
      }
    ];
  };
}
