{ config, lib, ... }:
let
  pickerMap = {
    snacks = "snacks_picker";
    fzf = "fzf_lua";
  };
in
{
  plugins.zk = {
    # zk-nvim documentation
    # See: https://github.com/zk-org/zk-nvim
    enable = lib.mkDefault true;

    lazyLoad.settings = {
      ft = "markdown";
      cmd = [
        "ZkIndex"
        "ZkNew"
        "ZkNotes"
        "ZkTags"
        "ZkLinks"
        "ZkBacklinks"
        "ZkMatch"
        "ZkInsertLink"
      ];
    };

    settings = {
      picker = pickerMap.${toString config.khanelivim.picker.tool} or "select";
      lsp.auto_attach = {
        enabled = true;
        filetypes = [ "markdown" ];
      };
    };
  };

  keymaps = lib.optionals config.plugins.zk.enable [
    {
      mode = "n";
      key = "<leader>nkn";
      action = "<cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>";
      options.desc = "New Note";
    }
    {
      mode = "n";
      key = "<leader>nko";
      action = "<cmd>ZkNotes { sort = { 'modified' } }<CR>";
      options.desc = "Open Notes";
    }
    {
      mode = "n";
      key = "<leader>nkt";
      action = "<cmd>ZkTags<CR>";
      options.desc = "Notes by Tag";
    }
    {
      mode = "n";
      key = "<leader>nkb";
      action = "<cmd>ZkBacklinks<CR>";
      options.desc = "Backlinks";
    }
    {
      mode = "n";
      key = "<leader>nkl";
      action = "<cmd>ZkLinks<CR>";
      options.desc = "Outgoing Links";
    }
    {
      mode = "v";
      key = "<leader>nkf";
      action = ":'<,'>ZkMatch<CR>";
      options.desc = "Find Notes Matching Selection";
    }
  ];
}
