-- ============================================================================
-- Leap Plugin Configuration
-- ============================================================================
-- Leap provides quick navigation by jumping to any location with minimal keystrokes

local leap = require('leap')

-- Setup leap with default configuration
leap.setup({
  case_sensitive = false,  -- Use case-insensitive search (like EasyMotion smartcase)
  safe_labels = {},        -- Use all labels for jumping
})

-- Set default keymaps
-- s: leap forward in current window
-- S: leap backward in current window
leap.create_default_mappings()

-- Additional keymap to match your EasyMotion workflow
-- Jump to word beginning (bidirectional - searches in all directions)
vim.keymap.set('n', '<Leader>l', function()
  require('leap').leap({ target_windows = { vim.fn.win_getid() } })
end, { noremap = true, silent = true, desc = 'Leap to any location' })
