{
  plugins = {
    obsidian = {
      enable = true;
      settings = {
        workspaces = [
          {
            name = "jot";
            path = "/home/birnx/dumper/jot";
          }
          {
            name = "jot2";
            path = "/home/birnx/dumper/jot2";
          }
        ];
        dir = "~/dumper";
        new_notes_location = "current_dir";
        completion = {
          min_chars = 2;
          blink = true;
        };
      };
    };
  };
}
