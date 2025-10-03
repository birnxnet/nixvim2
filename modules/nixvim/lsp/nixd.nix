{
  self,
  pkgs,
  ...
}:
{
  plugins.lsp = {
    # enable = true;

    servers = {
      nixd = {
        # Nix LS
        enable = true;
        settings =
          let
            # The wrapper curries `_nixd-expr.nix` with the `self` and `system` args
            # This makes `init.lua` a bit DRYer and more readable
            wrapper = builtins.toFile "expr.nix" ''
              import ${./_nixd-expr.nix} {
                self = ${builtins.toJSON self};
                system = ${builtins.toJSON pkgs.stdenv.hostPlatform.system};
              }
            '';
            # withFlakes brings `local` and `global` flakes into scope, then applies `expr`
            withFlakes = expr: "with import ${wrapper}; " + expr;
          in
          {
            nixpkgs.expr = withFlakes ''
              import (if local ? lib.version then local else local.inputs.nixpkgs or global.inputs.nixpkgs) { }
            '';
            options = {
              flake-parts.expr = withFlakes "local.debug.options or global.debug.options";
              nixos.expr = withFlakes "global.nixosConfigurations.desktop.options";
              home-manager.expr = withFlakes "global.home-manager.users.type.getSubOptions [ ]";
              nixvim.expr = withFlakes "global.nixvimConfigurations.\${system}.default.options";
            };
            diagnostic = {
              # Suppress noisy warnings
              suppress = [
                "sema-escaping-with"
                "var-bind-to-this"
              ];
            };
          };
      };
    };
  };
}
