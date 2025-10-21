-- Simple keymaps helper and common mappings
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- EasyMotion
-- Jump to word
map('n', '<Leader><Leader>w', '<Plug>(easymotion-w)', { noremap = false, silent = true })
-- Use space as EasyMotion leader (this is handled by the plugin's prefix)
map('', '<Leader>', '<Plug>(easymotion-prefix)', { noremap = false })

return {}
