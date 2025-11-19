{
  config,
  pkgs,
  systemConfig,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = systemConfig.user.fullName;
    userEmail = systemConfig.user.email;
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      core.autocrlf = false;
      credential.helper = "libsecret";
      rerere.enabled = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "/home/${systemConfig.user.username}/.ssh/id_ed25519.pub";
      #gpg.ssh.allowedSignersFile = "/home/${systemConfig.user.username}/.ssh/allowed_signers";
    };

    #difftastic.enable = true;
  };
}
