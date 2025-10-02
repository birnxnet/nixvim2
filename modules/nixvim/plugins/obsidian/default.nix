{
  plugins.render-markdown.enable = true;

  plugins.obsidian = {
    enable = true;

    settings = {
      workspaces = [
        {
          name = "jot";
          path = "~/dumper/jot";
        }
      ];

      ui.enable = false;

      # daily_notes = {
      #   folder = "daily";
      #   date_format = "%Y-%m-%d";
      #   alias_format = "%B %-d, %Y";
      #   template = null;
      # };
      # templates.subdir = "templates";

      picker.name = "snacks.pick";
      completion.blink = true;

      legacy_commands = false;
      notes_subdir = "notes";
      new_notes_location = "notes_subdir";
      note_id_func.__raw = ''
        function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            local suffix = ""
            if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                end
            end
            return tostring(os.time()) .. "-" .. suffix
        end
      '';
    };
  };
  keymaps = [
    {
      action = "<cmd>Obsidian quick_switch<CR>";
      key = "<leader>nf";
      options = {
        silent = true;
        desc = "Find Notes";
      };
    }
    {
      action = "<cmd>Obsidian search<CR>";
      key = "<leader>ns";
      options = {
        silent = true;
        desc = "Search Note Contents";
      };
    }
    {
      action = "<cmd>Obsidian new<CR>";
      key = "<leader>nn";
      options = {
        silent = true;
        desc = "Create New Note";
      };
    }
    {
      action = "<cmd>Obsidian link_new<CR>";
      key = "<leader>nn";
      mode = [ "v" ];
      options = {
        silent = true;
        desc = "Create New Note from selection";
      };
    }
    {
      action = "<cmd>Obsidian template<CR>";
      key = "<leader>nc";
      options = {
        silent = true;
        desc = "Insert Template";
      };
    }
    {
      action = "<cmd>Obsidian open<CR>";
      key = "<leader>no";
      options = {
        silent = true;
        desc = "Open in Obsidian";
      };
    }
    {
      action = "<cmd>Obsidian backlinks<CR>";
      key = "<leader>nb";
      options = {
        silent = true;
        desc = "Show Backlinks";
      };
    }
    {
      action = "<cmd>Obsidian today<CR>";
      key = "<leader>nT";
      options = {
        silent = true;
        desc = "Open Todays Note";
      };
    }
    {
      action = "<cmd>Obsidian tags<CR>";
      key = "<leader>nt";
      options = {
        silent = true;
        desc = "Show Tags";
      };
    }
  ];
}
