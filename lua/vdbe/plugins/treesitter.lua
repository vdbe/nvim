return {
  {
    "nvim-treesitter",
    event = vim.fn.argc(-1) == 0 and { "User", "BufReadPost", "BufNewFile", "BufWritePre" } or {},
    after = function()
      local ensure_installed
      if vim.g.is_nix then
        ensure_installed = {}
      else
        ensure_installed = {}
      end

      require("nvim-treesitter.configs").setup {
        auto_install = not vim.g.is_nix,
        ensure_installed = ensure_installed,
        indent = {
          enable = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then return true end
          end,
        },
      }

      -- Setup folding
      vim.o.foldenable = true
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
}
