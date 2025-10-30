{
  config,
  lib,
  pkgs,
  ...
}:
{
  lsp.servers.nixd = {
    enable = config.khanelivim.lsp.nix == "nixd";

    config.settings.nixd =
      # let
      #   # Yoinked from https://github.com/MattSturgeon/nix-config/commit/b8aa42d6c01465949ef5cd9d4dc086d4eaa36793
      #   # The wrapper curries `_nixd-expr.nix` with the `self` and `system` args
      #   wrapper = builtins.toFile "expr.nix" ''
      #     import ${./_nixd-expr.nix} {
      #       self = ${builtins.toJSON self};
      #       system = ${builtins.toJSON pkgs.stdenv.hostPlatform.system};
      #     }
      #   '';
      #
      #   # withFlakes brings `local` and `global` flakes into scope, then applies `expr`
      #   # withFlakes = expr: "with import ${wrapper}; " + expr;
      # in
      {
        nixpkgs.expr = ''
          import (if local ? lib.version then local else local.inputs.nixpkgs or global.inputs.nixpkgs) { }
        '';
        formatting = {
          command = [ "${lib.getExe pkgs.nixfmt}" ];
        };
        options = {
          flake-parts.expr = "local.debug.options or global.debug.options";
          nixvim.expr = "global.nixvimConfigurations.\${system}.default.options";
          # NOTE: These will be passed in from outside using `.extend` from the flake installing this package
          nixos.expr = ''local.nixosConfigurations.khanelinix.options'';
          home-manager.expr = ''local.home-manager.users.type.getSubOptions [ ]'';
        };
      };
  };
}
