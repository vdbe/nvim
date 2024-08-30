return {
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<F5>",  function() require("dap").continue() end,          desc = "Continue", },
      { "<F9>",  function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
      { "<F11>", function() require("dap").step_into() end,         desc = "Step Into", },
      { "<F10>", function() require("dap").step_over() end,         desc = "Step Over", },
      { "<S-F11>", function() require("dap").step_out() end,         desc = "Step Out", },
    },
  },
  { import = "lazyvim.plugins.extras.dap.core" },
}
