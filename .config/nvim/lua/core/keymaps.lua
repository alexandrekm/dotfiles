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
-- COMMENTING (Built-in Neovim 0.10+)
-- ============================================================================
-- Neovim 0.10+ has native commenting via 'gc' operator
-- Remap to leader+c for convenience
map('n', '<leader>c', 'gcc', { remap = true, silent = true, desc = 'Toggle comment line' })
map('x', '<leader>c', 'gc', { remap = true, silent = true, desc = 'Toggle comment selection' })

return {}
