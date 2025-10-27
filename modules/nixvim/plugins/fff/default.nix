{ config, lib, ... }:
{
  plugins.fff = {
    enable = true;

    settings = {
      debug = {
        enabled = true;
        show_scores = true;
      };
      preview = {
        enabled = true;
        line_numbers = true;
        wrap_lines = true;
      };
    };
  };

  plugins.which-key.settings.spec = lib.mkIf config.plugins.fff.enable [
    {
      __unkeyed-1 = "<leader>fF";
      group = "File Filter";
      icon = "󰈞";
    }
  ];

  keymaps = lib.optionals config.plugins.fff.enable [
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>lua require('fff').find_in_git_root()<CR>";
      options = {
        desc = "Find files in git repository";
      };
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = "<cmd>lua require('fff').scan_files()<CR>";
      options = {
        desc = "Rescan files in current directory";
      };
    }
    {
      mode = "n";
      key = "<leader>fR";
      action = "<cmd>lua require('fff').refresh_git_status()<CR>";
      options = {
        desc = "Refresh git status";
      };
    }

    # Directory-specific searches using FFFFind command
    {
      mode = "n";
      key = "<leader>fFf";
      action = "<cmd>FFFFind flake<CR>";
      options = {
        desc = "Find flake files";
      };
    }
    {
      mode = "n";
      key = "<leader>fFm";
      action = "<cmd>FFFFind modules<CR>";
      options = {
        desc = "Find module files";
      };
    }
    {
      mode = "n";
      key = "<leader>fFo";
      action = "<cmd>FFFFind overlays<CR>";
      options = {
        desc = "Find overlay files";
      };
    }
    {
      mode = "n";
      key = "<leader>fFp";
      action = "<cmd>FFFFind packages<CR>";
      options = {
        desc = "Find package files";
      };
    }
    {
      mode = "n";
      key = "<leader>fFr";
      action = "<cmd>FFFFind result<CR>";
      options = {
        desc = "Find result files";
      };
    }
    {
      mode = "n";
      key = "<leader>fFs";
      action = "<cmd>FFFFind shells<CR>";
      options = {
        desc = "Find shell files";
      };
    }
    {
      mode = "n";
      key = "<leader>fFc";
      action = "<cmd>FFFFind .<CR>";
      options = {
        desc = "Find current directory";
      };
    }

    # Additional useful directory searches
    {
      mode = "n";
      key = "<leader>fFa";
      action = "<cmd>FFFFind assets<CR>";
      options = {
        desc = "Find asset files";
      };
    }
    {
      mode = "n";
      key = "<leader>fFd";
      action = "<cmd>lua require('fff').find_files_in_dir(vim.fn.expand('~/.config'))<CR>";
      options = {
        desc = "Find files in ~/.config";
      };
    }
    {
      mode = "n";
      key = "<leader>fFh";
      action = "<cmd>lua require('fff').find_files_in_dir(vim.fn.expand('~'))<CR>";
      options = {
        desc = "Find files in home directory";
      };
    }

    # Interactive directory change and search
    {
      mode = "n";
      key = "<leader>fFi";
      action = "<cmd>lua require('fff').change_indexing_directory(vim.fn.input('Directory: ', vim.fn.getcwd(), 'dir'))<CR>";
      options = {
        desc = "Change indexing directory interactively";
      };
    }
  ];
}
