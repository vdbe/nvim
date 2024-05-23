{ ... }:
_: super: {
  tree-sitter-typescript = super.tree-sitter-typescript // {
    location = "typescript";
  };
  tree-sitter-tsx = super.tree-sitter-typescript // {
    location = "tsx";
  };
}
