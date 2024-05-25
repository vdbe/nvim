{ lib, ... }:
let
  inherit (lib) fileset;
in
fileset.toSource {
  root = ../../../.;
  fileset = fileset.unions [
    ../../../lua
    ../../../plugin
  ];
}
