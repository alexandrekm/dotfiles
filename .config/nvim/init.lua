-- Minimal Neovim Lua entry (init.lua)
-- Bootstraps lazy.nvim and loads core and plugins

-- Polyfill vim.keycode for backward compatibility or missing implementations
if not vim.keycode then
  vim.keycode = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Core settings and keymaps
pcall(require, 'core.options')
pcall(require, 'core.keymaps')

-- Plugins (managed by lazy.nvim)
pcall(require, 'plugins')
