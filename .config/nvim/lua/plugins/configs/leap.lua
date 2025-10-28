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

-- Set up keymaps manually (replaces deprecated create_default_mappings)
-- s: leap forward in current window
vim.keymap.set('n', 's', '<Plug>(leap-forward)', { noremap = false, silent = true })
vim.keymap.set('n', 'S', '<Plug>(leap-backward)', { noremap = false, silent = true })

-- Visual and operator-pending mode mappings
vim.keymap.set({'x', 'o'}, 's', '<Plug>(leap-forward)', { noremap = false, silent = true })
vim.keymap.set({'x', 'o'}, 'S', '<Plug>(leap-backward)', { noremap = false, silent = true })

-- Additional keymap to match your EasyMotion workflow
-- Jump to word beginning (bidirectional - searches in all directions)
vim.keymap.set('n', '<Leader>l', function()
  require('leap').leap({ target_windows = { vim.fn.win_getid() } })
end, { noremap = true, silent = true, desc = 'Leap to any location' })
