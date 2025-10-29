{ config, lib, ... }:
{
  plugins = {
    debugprint = {
      enable = lib.elem "debugprint" config.khanelivim.debugging.adapters;

      lazyLoad.settings = {
        keys = [
          "g?"
        ];
        cmd = [
          "DeleteDebugPrints"
          "ResetDebugPrintsCounter"
          "ToggleCommentDebugPrints"
        ];
      };

      settings = {
        commands = {
          toggle_comment_debug_prints = "ToggleCommentDebugPrints";
          delete_debug_prints = "DeleteDebugPrints";
        };

        display_counter = true;
        display_snippet = true;

        keymaps = {
          normal = {
            plain_below = "g?p";
            plain_above = "g?P";
            variable_below = "g?v";
            variable_above = "g?V";
            variable_below_alwaysprompt.__raw = "nil";
            variable_above_alwaysprompt.__raw = "nil";
            textobj_below = "g?o";
            textobj_above = "g?O";
            toggle_comment_debug_prints.__raw = "nil";
            delete_debug_prints.__raw = "nil";
          };
          visual = {
            variable_below = "g?v";
            variable_above = "g?V";
          };
        };
      };
    };
  };
}
