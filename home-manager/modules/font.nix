{...}: {
 fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig/conf.d/60-apple-emoji.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <alias>
        <family>emoji</family>
        <prefer>
          <family>Apple Color Emoji</family>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>

      <alias>
        <family>Noto Color Emoji</family>
        <prefer>
          <family>Apple Color Emoji</family>
        </prefer>
      </alias>
    </fontconfig>
  '';
}