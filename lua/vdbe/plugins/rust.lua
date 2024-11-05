return {
  {
    "rustaceanvim",
    ft = "rust",
    before = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp "codeAction" end)
            vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp "debuggables" end, { buffer = bufnr })
          end,
          tools = {
            float_win_config = {
              border = "rounded",
            },
          },
          settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                },
              },
            },
          },
        },
      }
    end,
  },
  {
    "crates.nvim",
    after = function() require("crates").setup {} end,
    event = "BufRead Cargo.toml",
  },
}
