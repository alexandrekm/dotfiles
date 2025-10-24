-- ============================================================================
-- Neovim Keymaps Configuration
-- ============================================================================
-- This file contains all custom key mappings organized by functionality.
-- Uses vim.keymap.set for setting keymaps with consistent options.

-- ============================================================================
-- HELPER FUNCTIONS & OPTIONS
-- ============================================================================
local map = vim.keymap.set           -- Shorthand for vim.keymap.set
local opts = { noremap = true, silent = true }  -- Default options: no recursive mapping, silent execution

-- ============================================================================
-- WINDOW NAVIGATION
-- ============================================================================
-- Better window navigation using Ctrl + hjkl (similar to tmux/vim splits)
map('n', '<C-h>', '<C-w>h', opts)    -- Move to left window
map('n', '<C-j>', '<C-w>j', opts)    -- Move to window below
map('n', '<C-k>', '<C-w>k', opts)    -- Move to window above
map('n', '<C-l>', '<C-w>l', opts)    -- Move to right window

-- ============================================================================
-- EASYMOTION PLUGIN
-- ============================================================================
-- EasyMotion provides quick navigation by highlighting jump targets
-- Jump to word beginning
map('n', '<Leader>l', '<Plug>(easymotion-w)', { noremap = false, silent = true })

return {}
