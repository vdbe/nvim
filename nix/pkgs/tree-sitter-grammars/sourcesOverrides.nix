_: _: super: {
  tree-sitter-latex = super.tree-sitter-latex // {
    generate = true;
  };

  tree-sitter-markdown = super.tree-sitter-markdown // {
    location = "tree-sitter-markdown";
  };

  tree-sitter-markdown-inline = super.tree-sitter-markdown // {
    location = "tree-sitter-markdown";
  };

  tree-sitter-typescript = super.tree-sitter-typescript // {
    location = "typescript";
  };

  tree-sitter-tsx = super.tree-sitter-typescript // {
    location = "tsx";
  };
}
