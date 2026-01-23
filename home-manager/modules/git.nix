{
  config,
  pkgs,
  systemConfig,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
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
      #gpg.ssh.allowedSignersFile = "/home/${systemConfig.user.username}/.ssh/allowed_signers";
    };

    #difftastic.enable = true;
  };
}
