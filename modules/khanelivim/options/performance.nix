{ lib, ... }:
{
  options.khanelivim.performance = {
    optimizer = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.listOf (
          lib.types.enum [
            "faster"
            "snacks"
          ]
        )
      );
      default = [ "faster" ];
      description = "Performance optimization strategies for large files (can use multiple)";
    };

    optimizeEnable =
      lib.mkEnableOption "nixvim performance optimizations (byte compilation, plugin combining)"
      // {
        default = true;
      };
  };
}
