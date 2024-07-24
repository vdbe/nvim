_: _: super: {
  tree-sitter-latex = super.tree-sitter-latex // {
    generate = true;
  };

  tree-sitter-typescript = super.tree-sitter-typescript // {
    location = "typescript";
  };

  tree-sitter-tsx = super.tree-sitter-typescript // {
    location = "tsx";
  };
}
