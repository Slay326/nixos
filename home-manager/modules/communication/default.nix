{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    vesktop
    mattermost-desktop
  ];

  home.activation.disableMattermostAutostart = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mattermost_config="$HOME/.config/Mattermost/config.json"
    if [ -e "$mattermost_config" ]; then
      tmp_config="$(mktemp)"
      ${pkgs.jq}/bin/jq '.autostart = false' "$mattermost_config" > "$tmp_config"
      install -m 0644 "$tmp_config" "$mattermost_config"
      rm -f "$tmp_config"
    fi

    electron_autostart="$HOME/.config/autostart/electron.desktop"
    if [ -e "$electron_autostart" ] \
      && grep -qx 'Name=electron' "$electron_autostart" \
      && grep -qx 'Comment=electronstartup script' "$electron_autostart"; then
      rm -f "$electron_autostart"
    fi
  '';

  xdg.desktopEntries.vesktop = {
    name = "Vesktop";
    genericName = "Discord Client";
    exec = "vesktop %U";
    icon = "discord";
    categories = ["Network" "InstantMessaging"];
    terminal = false;
    type = "Application";
  };
}
