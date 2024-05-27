local Common = require "common"

return {
  {
    "AstroNvim/astrocore",
    lazy = false, -- disable lazy loading
    priority = 10000, -- load AstroCore first
    opts = function(_, opts)
      local get_icon = require("astroui").get_icon
      opts = {
        diagnostics = {
          virtual_text = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = get_icon "DiagnosticError",
              [vim.diagnostic.severity.HINT] = get_icon "DiagnosticHint",
              [vim.diagnostic.severity.WARN] = get_icon "DiagnosticWarn",
              [vim.diagnostic.severity.INFO] = get_icon "DiagnosticInfo",
            },
          },
          update_in_insert = true,
          underline = true,
          severity_sort = true,
          float = {
            focused = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
          },
        },
        options = Common.options,
        features = {
          autopairs = true, -- enable or disable autopairs on start
          cmp = true, -- enable or disable cmp on start
          diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = off)
          highlighturl = true, -- enable or disable highlighting of urls on start
          -- table for defining the size of the max file for all features, above these limits we disable features like treesitter.
          large_buf = { size = 1024 * 100, lines = 10000 },
          notifications = false, -- enable or disable notifications on start
        },
        rooter = {
          enable = false,
          -- list of detectors in order of prevalence, elements can be:
          --   "lsp" : lsp detection
          --   string[] : a list of directory patterns to look for
          --   fun(bufnr: integer): string|string[] : a function that takes a buffer number and outputs detected roots
          detector = {
            "lsp", -- highest priority is getting workspace from running language servers
            { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- next check for a version controlled parent directory
            { "lua", "MakeFile", "package.json" }, -- lastly check for known project root files
          },
          -- ignore things from root detection
          ignore = {
            servers = {}, -- list of language server names to ignore (Ex. { "efm" })
            dirs = {}, -- list of directory patterns (Ex. { "~/.cargo/*" })
          },
          -- automatically update working directory (update manually with `:AstroRoot`)
          autochdir = false,
          -- scope of working directory to change ("global"|"tab"|"win")
          scope = "global",
          -- show notification on every working directory change
          notify = false,
        },
      }

      -- initialize internally use mapping section titles
      opts._map_sections = {
        f = { desc = get_icon("Search", 1, true) .. "Find" },
        l = { desc = get_icon("ActiveLSP", 1, true) .. "Language Tools" },
        u = { desc = get_icon("Window", 1, true) .. "UI/UX" },
        b = { desc = get_icon("Tab", 1, true) .. "Buffers" },
        bs = { desc = get_icon("Sort", 1, true) .. "Sort Buffers" },
        d = { desc = get_icon("Debugger", 1, true) .. "Debugger" },
        g = { desc = get_icon("Git", 1, true) .. "Git" },
        S = { desc = get_icon("Session", 1, true) .. "Session" },
        t = { desc = get_icon("Terminal", 1, true) .. "Terminal" },
      }

      local maps = Common.keymaps
      local sections = opts._map_sections

      -- Manage Buffers
      maps.n["<Leader>c"] = { function() require("astrocore.buffer").close() end, desc = "Close buffer" }
      maps.n["<Leader>C"] = { function() require("astrocore.buffer").close(0, true) end, desc = "Force close buffer" }
      maps.n["]b"] = {
        function() require("astrocore.buffer").nav(vim.v.count1) end,
        desc = "Next buffer",
      }
      maps.n["[b"] = {
        function() require("astrocore.buffer").nav(-vim.v.count1) end,
        desc = "Previous buffer",
      }
      maps.n[">b"] = {
        function() require("astrocore.buffer").move(vim.v.count1) end,
        desc = "Move buffer tab right",
      }
      maps.n["<b"] = {
        function() require("astrocore.buffer").move(-vim.v.count1) end,
        desc = "Move buffer tab left",
      }

      maps.n["<Leader>b"] = vim.tbl_get(sections, "b")
      maps.n["<Leader>bc"] =
        { function() require("astrocore.buffer").close_all(true) end, desc = "Close all buffers except current" }
      maps.n["<Leader>bC"] = { function() require("astrocore.buffer").close_all() end, desc = "Close all buffers" }
      maps.n["<Leader>bl"] =
        { function() require("astrocore.buffer").close_left() end, desc = "Close all buffers to the left" }
      maps.n["<Leader>bp"] = { function() require("astrocore.buffer").prev() end, desc = "Previous buffer" }
      maps.n["<Leader>br"] =
        { function() require("astrocore.buffer").close_right() end, desc = "Close all buffers to the right" }
      maps.n["<Leader>bs"] = vim.tbl_get(sections, "bs")
      maps.n["<Leader>bse"] = { function() require("astrocore.buffer").sort "extension" end, desc = "By extension" }
      maps.n["<Leader>bsr"] =
        { function() require("astrocore.buffer").sort "unique_path" end, desc = "By relative path" }
      maps.n["<Leader>bsp"] = { function() require("astrocore.buffer").sort "full_path" end, desc = "By full path" }
      maps.n["<Leader>bsi"] = { function() require("astrocore.buffer").sort "bufnr" end, desc = "By buffer number" }
      maps.n["<Leader>bsm"] = { function() require("astrocore.buffer").sort "modified" end, desc = "By modification" }

      maps.n["<Leader>u"] = vim.tbl_get(sections, "u")
      -- Custom menu for modification of the user experience
      maps.n["<Leader>uA"] =
        { function() require("astrocore.toggles").autochdir() end, desc = "Toggle rooter autochdir" }
      maps.n["<Leader>ub"] = { function() require("astrocore.toggles").background() end, desc = "Toggle background" }
      maps.n["<Leader>ud"] = { function() require("astrocore.toggles").diagnostics() end, desc = "Toggle diagnostics" }
      maps.n["<Leader>ug"] = { function() require("astrocore.toggles").signcolumn() end, desc = "Toggle signcolumn" }
      maps.n["<Leader>u>"] = { function() require("astrocore.toggles").foldcolumn() end, desc = "Toggle foldcolumn" }
      maps.n["<Leader>ui"] = { function() require("astrocore.toggles").indent() end, desc = "Change indent setting" }
      maps.n["<Leader>ul"] = { function() require("astrocore.toggles").statusline() end, desc = "Toggle statusline" }
      maps.n["<Leader>un"] = { function() require("astrocore.toggles").number() end, desc = "Change line numbering" }
      maps.n["<Leader>uN"] =
        { function() require("astrocore.toggles").notifications() end, desc = "Toggle Notifications" }
      maps.n["<Leader>up"] = { function() require("astrocore.toggles").paste() end, desc = "Toggle paste mode" }
      maps.n["<Leader>us"] = { function() require("astrocore.toggles").spell() end, desc = "Toggle spellcheck" }
      maps.n["<Leader>uS"] = { function() require("astrocore.toggles").conceal() end, desc = "Toggle conceal" }
      maps.n["<Leader>ut"] = { function() require("astrocore.toggles").tabline() end, desc = "Toggle tabline" }
      maps.n["<Leader>uu"] = { function() require("astrocore.toggles").url_match() end, desc = "Toggle URL highlight" }
      maps.n["<Leader>uw"] = { function() require("astrocore.toggles").wrap() end, desc = "Toggle wrap" }
      maps.n["<Leader>uy"] =
        { function() require("astrocore.toggles").buffer_syntax() end, desc = "Toggle syntax highlight" }

      opts.mappings = maps
      return opts
    end,
    dependencies = {
      {
        "AstroNvim/AstroNvim",
        lazy = true, -- disable lazy loading
        priority = 10000, -- load AstroCore first
        module = true,
        config = false,
      },
    },
  },
  { import = "astronvim.plugins._astrocore_autocmds" },
  {
    "AstroNvim/astrocommunity",
    lazy = false,
    module = true,
    config = false,
  },
}
