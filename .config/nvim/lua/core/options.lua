-- Core options (vim.opt and vim.g)
local M = {}

local o = vim.opt
local g = vim.g

-- Leader
g.mapleader = " "

-- UI
o.number = true
o.relativenumber = true
o.termguicolors = true
o.signcolumn = "yes"

-- Editing
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

o.wrap = false
o.hidden = true

-- Files
o.swapfile = false
o.backup = false
o.writebackup = false
o.undofile = true

-- Performance
o.updatetime = 300

-- Clipboard
o.clipboard = "unnamedplus"

return M
