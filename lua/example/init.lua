vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set({ "!", "t" }, "jk", [[<c-\><c-n>]], { desc = "Exit to normal mode" })

local plugins_root = nil
if vim.g.is_nix ~= true then
  vim.g.is_nix = false
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release:
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
else
  vim.cmd [[packadd lazy.nvim]]
  plugins_root = vim.g.nix_packpath .. "/pack/myNeovimPackages/opt"
end

require("lazy").setup({ -- plugins
  import = "comet.plugins",
}, { -- opts
  root = plugins_root,
  defaults = {
    lazy = true,
  },
  install = {
    missing = not vim.g.is_nix,
  },
  change_detection = {
    notify = not vim.g.is_nix,
  },
})
