-- ============================================================================
-- EasyMotion Plugin Configuration
-- ============================================================================
-- EasyMotion provides quick navigation by highlighting jump targets

-- Local keymap function
local map = vim.keymap.set

-- Search behavior
vim.g.EasyMotion_smartcase = 1          -- Use case-insensitive search (smart case)

-- Scope and appearance settings
vim.g.EasyMotion_scrolloff = 10         -- Limit search to 10 lines above and below visible cursor
vim.g.EasyMotion_move_highlight = false -- Don't highlight cursor movement
vim.g.EasyMotion_landing_highlight = false -- Don't highlight landing position

-- Jump to word beginning (bidirectional - highlights words above AND below cursor)
map('n', '<Leader>l', '<Plug>(easymotion-bd-w)', { noremap = false, silent = true })