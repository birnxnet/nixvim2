{ lib, ... }:
{
  options.khanelivim.picker = {
    tool = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "snacks"
          "telescope"
          "fzf"
        ]
      );
      default = "snacks";
      description = "Fuzzy finder/picker tool to use";
    };
  };
}
