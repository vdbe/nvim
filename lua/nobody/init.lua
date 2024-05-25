vim.g.mapleader = " "
vim.g.maplocalleader = ","

local plugins_root = nil
if vim.g.is_nix ~= true then
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release:
      lazypath
    })
  end
  vim.opt.rtp:prepend(lazypath)
else
  vim.cmd [[packadd lazy.nvim]]
  plugins_root = vim.g.nix_plugins_path .. "/pack/myNeovimPackages/opt"
end

require("lazy").setup(
  { -- plugins
    import = "nobody.plugins",
  },
  { -- opts
    root = plugins_root;
    install = {
      missing = vim.g.is_nix ~= true,
    },
    change_detection = {
      notify = vim.g.is_nix ~= true,
    },
  }
)
