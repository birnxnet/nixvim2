{
  extraConfigLuaPre = ''
    function bool2str(bool) return bool and "on" or "off" end

    require("obsidian").setup({
      legacy_commands = false,
    })
  '';
}
