{
  config,
  pkgs,
  systemConfig,
  ...
}: let
  activeUser = systemConfig.slay.activeUser or {};
  userName = activeUser.fullName or activeUser.username or "";
  userEmail =
    if activeUser ? email
    then activeUser.email
    else "";
  signingHome =
    if activeUser ? home
    then activeUser.home
    else "/home/${activeUser.username or "user"}";
in {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = userName;
    userEmail = userEmail;
    lfs.enable = true;
    settings = {
      user = {
        name = systemConfig.user.fullName;
        email = systemConfig.user.email;
        signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
      init.defaultBranch = "main";
      core.autocrlf = false;
      credential.helper = "libsecret";
      rerere.enabled = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "${signingHome}/.ssh/id_ed25519.pub";
      #gpg.ssh.allowedSignersFile = "${signingHome}/.ssh/allowed_signers";
    };

    #difftastic.enable = true;
  };
}
