{ self, pkgs }:
let
  inherit (pkgs) lib;

  packages = self.packages.${pkgs.system};

  mkHeadlessCheck =
    name: drvArgs: nvimArgs:
    pkgs.runCommand name drvArgs ''
      export HOME="$(mktemp -d)"
      nvim --headless ${nvimArgs} +qa 2>$out

      cat $out
      test -s $out && exit 1

      exit 0
    '';

  variants = [
    "default"
    "default.noPlugins"
    "default.minimal"
  ];

  headless-checks = builtins.listToAttrs (
    map (
      variant:
      let
        name = "check-headles#${variant}";
        explodedVariant = pkgs.lib.splitString "." variant;
        variantDrv = lib.attrByPath explodedVariant (throw "unknown variant") packages;
      in
      {
        inherit name;
        value = mkHeadlessCheck name { buildInputs = [ variantDrv ]; } "";
      }
    ) variants
  );
in
headless-checks
// {
  check-treesitter-grammars = mkHeadlessCheck "check-headless" {
    buildInputs = [ packages.neovim ];
  } "test.rs +InspectTree";

  # check-health = pkgs.runCommand "check-lazy-health" {} ''
  #   mkdir -p $out{.config, .local/state, .local/share, .cache}
  #   XDG_CONFIG_HOME="$out/.config" \
  #     XDG_STATE_HOME="$out/.local/state" \
  #     XDG_CACHE_HOME="$out/.cache" \
  #     XDG_DATA_HOME="$out/.local/share" \
  #     ${lib.getExe nvim} --headless "+checkhealth" "+w!$out/health.log" +qa
  #
  #   cat "$out/health.log"
  #
  #   cat "$out/health.log" | ${lib.getExe pkgs.gawk} '
  #     {
  #       if (/ERROR/) {
  #         type = "error";
  #         title = "Error";
  #       } else if (/WARNING/) {
  #         type = "warning";
  #         title = "Warning";
  #       } else {
  #         next;
  #       }
  #
  #       start_line = NR;
  #       message = $0;
  #       getline;
  #       while ($0 ~ /^- (ERROR|WARNING)/) {
  #         message = message "\n" $0;
  #         getline;
  #       }
  #       message = message "\n" $0;
  #       end_line = NR - 1;
  #
  #       # Print the GitHub Actions command
  #       printf "::%s file=health.log,line=%d,endLine=%d,title=%s::%s\n", type, start_line, end_line, title, message;
  #     }
  #   ' > "$out/health.error"
  #
  #   cat "$out/health.error"
  #   test -s "$out/health.error" && exit 1
  # '';
}
