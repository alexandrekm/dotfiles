-- NERDCommenter config (converted from .nvimrc)
vim.g.NERDCreateDefaultMappings = 0

vim.g.NERDSpaceDelims = 1
vim.g.NERDCompactSexyComs = 1
vim.g.NERDTrimTrailingWhitespace = 1

-- Define custom keymaps for normal and visual mode
local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Normal mode
keymap("n", "<leader>c", "<Plug>NERDCommenterToggle", opts)

-- Visual mode
keymap("v", "<leader>c", "<Plug>NERDCommenterToggle", opts)
