{
  config,
  lib,
  self,
  system,
  ...
}:
{
  plugins = {
    treesitter = {
      enable = true;

      folding = true;
      grammarPackages =
        let
          # Large grammars that are not used
          excludedGrammars = [
            "agda-grammar"
            "cuda-grammar"
            "d-grammar"
            "fortran-grammar"
            "gnuplot-grammar"
            "haskell-grammar"
            "hlsl-grammar"
            "julia-grammar"
            "koto-grammar"
            "lean-grammar"
            "nim-grammar"
            "scala-grammar"
            "slang-grammar"
            "systemverilog-grammar"
            "tlaplus-grammar"
            "verilog-grammar"
          ];
        in
        lib.filter (
          g: !(lib.elem g.pname excludedGrammars)
        ) config.plugins.treesitter.package.passthru.allGrammars
        ++ [
          self.packages.${system}.tree-sitter-norg-meta
        ];
      nixvimInjections = true;

      settings = {
        highlight = {
          additional_vim_regex_highlighting = true;
          enable = true;
          disable = # Lua
            ''
              function(lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 10000
              end
            '';
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "gnn";
            node_incremental = "grn";
            scope_incremental = "grc";
            node_decremental = "grm";
          };
        };

        indent = {
          enable = true;
        };
      };
    };

    treesitter-context = {
      inherit (config.plugins.treesitter) enable;
      settings = {
        max_lines = 4;
        min_window_height = 40;
        multiwindow = true;
        separator = "-";
      };
    };

    treesitter-refactor = {
      inherit (config.plugins.treesitter) enable;

      settings = {

        highlight_definitions = {
          enable = true;
          clearOnCursorMove = true;
        };
        smart_rename = {
          enable = true;
          keymaps = {
            # NOTE: default is "grr"
            # Changed from grR to gR to avoid conflict with gr (References)
            smart_rename = "gR";
          };
        };
        navigation = {
          enable = true;
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.treesitter-context.enable [
    {
      mode = "n";
      key = "<leader>ut";
      action = "<cmd>TSContextToggle<cr>";
      options = {
        desc = "Treesitter Context toggle";
      };
    }
  ];
}
