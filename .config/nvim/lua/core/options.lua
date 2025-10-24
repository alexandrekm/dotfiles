-- Core options (vim.opt and vim.g)
local M = {}

local o = vim.opt
local g = vim.g

-- Leader
g.mapleader = ";"

-- UI
o.number = true
o.relativenumber = false
o.termguicolors = true
o.signcolumn = "yes"

-- Editing
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

-- Enable visual wrapping (no actual newlines added)
o.wrap = true
-- Break lines at word boundaries, not mid-word
o.linebreak = true
-- Add a visible prefix for wrapped lines
o.showbreak = "↳  "
o.hidden = true

-- Files
o.swapfile = true
o.backup = true
o.writebackup = false
-- Enable persistent undo history saved to disk, letting you undo across sessions
o.undofile = true

-- Performance
o.updatetime = 300

-- Clipboard
o.clipboard = "unnamedplus"

return M
