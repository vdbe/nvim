local lspconfig = require "lspconfig"

vim.diagnostic.config {
  underline = true,
  update_in_insert = true,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    -- prefix = "icons",
  },
  severity_sort = true,
  -- signs = {
  --   text = {
  --     [vim.diagnostic.severity.ERROR] = "E",
  --     [vim.diagnostic.severity.WARN] = "W",
  --     [vim.diagnostic.severity.HINT] = "H",
  --     [vim.diagnostic.severity.INFO] = "I",
  --   },
  -- },
}

local servers = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        codeLens = {
          enable = true,
        },
        completion = {
          callSnippet = "Replace",
        },
        doc = {
          privateName = { "^_" },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
      },
    },
  },
  nixd = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = "import <nixpkgs> { }",
        },
        formatting = {
          command = { "nixfmt" },
        },
      },
    },
  },
}

local function on_attach(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)

  if client == nil then return end

  -- if navic_present and client.server_capabilities.documentSymbolProvider then navic.attach(client, ev.buf) end

  if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf }) end

  -- local opts = { buffer = ev.buf }
  require("vdbe.plugins.lsp.keymaps").on_attach(ev.buf)
  --
  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  -- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  -- vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
  -- -- NOTE: this overwrites `gr`` but I have no idea what the use for that would be
  -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
end

-- Stolen from https://github.com/hrsh7th/cmp-nvim-lsp/blob/39e2eda76828d88b773cc27a3f61d2ad782c922d/lua/cmp_nvim_lsp/init.lua#L37
local cmp_capabilities = {
  textDocument = {
    completion = {
      dynamicRegistration = false,
      completionItem = {
        snippetSupport = true,
        commitCharactersSupport = true,
        deprecatedSupport = true,
        preselectSupport = true,
        tagSupport = {
          valueSet = {
            1, -- Deprecated
          },
        },
        insertReplaceSupport = true,
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
            "sortText",
            "filterText",
            "insertText",
            "textEdit",
            "insertTextFormat",
            "insertTextMode",
          },
        },
        insertTextModeSupport = {
          valueSet = {
            1, -- asIs
            2, -- adjustIndentation
          },
        },
        labelDetailsSupport = true,
      },
      contextSupport = true,
      insertTextMode = 1,
      completionList = {
        itemDefaults = {
          "commitCharacters",
          "editRange",
          "insertTextFormat",
          "insertTextMode",
          "data",
        },
      },
    },
  },
}

local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_capabilities, {
  {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = true },
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  },
})

local common_lsp_server_config = {
  -- NOTE: Check is `vim.lsp.protocol.make_client_capabilities` is added by
  -- default
  capabilities = capabilities,
}
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = on_attach,
})

for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_extend("force", common_lsp_server_config, config))
end
