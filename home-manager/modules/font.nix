{...}: {
 fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig/conf.d/60-apple-emoji.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>

      <!-- If something asks for the generic "emoji" family, force Apple first -->
      <match target="pattern">
        <test name="family" compare="eq">
          <string>emoji</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          <string>Apple Color Emoji</string>
        </edit>
      </match>

      <!-- If something explicitly asks for Noto Color Emoji, still prefer Apple -->
      <match target="pattern">
        <test name="family" compare="eq">
          <string>Noto Color Emoji</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          <string>Apple Color Emoji</string>
        </edit>
      </match>

    </fontconfig>
  '';
}