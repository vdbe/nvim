{
  lib,
  tree-sitter-grammars,
  neovimUtils,
  tree-sitter,
  runCommand,
  neovim,
}: self: super: let
  inherit (builtins) attrValues;
  inherit (neovimUtils) grammarToPlugin;

  generatedDerivations = lib.filterAttrs (_: lib.isDerivation) tree-sitter-grammars;

  # add aliases so grammars from `tree-sitter` are overwritten in `withPlugins`
  # for example, for tree-siiter-ocaml_interface, the following aliases will be added
  #   ocaml-interface
  #   tree-sitter-ocaml-interface
  #   tree-sitter-ocaml_interface
  builtGrammars =
    generatedDerivations
    // lib.concatMapAttrs
    (k: v: let
      name = lib.removePrefix "tree-sitter-" k;
      replaced = lib.replaceStrings ["_"] ["-"] name;
    in
      {
        ${name} = v;
      }
      // lib.optionalAttrs (name != replaced) {
        ${replaced} = v;
        "tree-sitter-${replaced}" = v;
      })
    generatedDerivations;

  allGrammars = attrValues generatedDerivations;

  # Usage:
  # pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.java ... ])
  # or for all grammars:
  # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  withPlugins = f:
    self.nvim-treesitter.overrideAttrs {
      passthru.dependencies =
        map grammarToPlugin
        (f (tree-sitter.builtGrammars // builtGrammars));
    };

  withAllGrammars = withPlugins (_: allGrammars);
in {
  postPatch = ''
    rm -r parser
  '';

  passthru =
    (super.nvim-treesitter.passthru or {})
    // {
      inherit builtGrammars allGrammars grammarToPlugin withPlugins withAllGrammars;

      grammarPlugins = lib.mapAttrs (_: grammarToPlugin) generatedDerivations;

      tests.check-queries = let
        nvimWithAllGrammars = neovim.override {
          configure.packages.all.start = [withAllGrammars];
        };
      in
        runCommand "nvim-treesitter-check-queries"
        {
          nativeBuildInputs = [nvimWithAllGrammars];
          CI = true;
        }
        ''
          touch $out
          export HOME=$(mktemp -d)
          ln -s ${withAllGrammars}/CONTRIBUTING.md .

          nvim --headless "+luafile ${withAllGrammars}/scripts/check-queries.lua" | tee log

          if grep -q Warning log; then
            echo "Error: warnings were emitted by the check"
            exit 1
          fi
        '';
    };

  meta =
    (super.nvim-treesitter.meta or {})
    // {
      license = lib.licenses.asl20;
      maintainers = [];
    };
}
