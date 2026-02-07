{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
  ];
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
