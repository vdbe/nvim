{ lib, callPackage, ... }:
let
  inherit (builtins) mapAttrs removeAttrs;
  inherit (lib.fixedPoints) extends;

  grammarSources = import ../../sources/grammars;

  sourcesOverrides = callPackage ./sourcesOverrides.nix { };

  grammarSources' = removeAttrs (callPackage (extends sourcesOverrides (_: grammarSources)) { }) [
    "override"
    "overrideDerivation"
  ];

  buildGrammar = callPackage ./grammar.nix { };
  mkGrammars =
    let
      build =
        name: grammar:
        buildGrammar {
          language = grammar.language or name;
          version = grammar.version or grammar.revision;
          src = grammar;
          location = grammar.location or null;
          generate = grammar.generate or false;
        };
    in
    mapAttrs build;

  grammars = mkGrammars grammarSources';
in
grammars
