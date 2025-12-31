-- Plugin list for lazy.nvim
-- Each entry is a table describing a plugin. Keep this file lean and move heavy configs
-- to `plugins/configs/*.lua` to keep startup fast.
local plugins = {

  -- Leap (navigation plugin)
  {
    'ggandor/leap.nvim',
    config = function() require('plugins.configs.leap') end,
  },

  -- Backport native commenting for Neovim < 0.10
  -- This provides 'gcc' and 'gc' functionality on older versions like Ubuntu 22.04's defaults
  {
    'echasnovski/mini.comment',
    version = '*',
    cond = function() return vim.fn.has('nvim-0.10') == 0 end,
    config = function()
      require('mini.comment').setup()
    end,
  },
}

require('lazy').setup(plugins, {
  ui = {
    -- Disable 'S' keybinding in Lazy UI to avoid conflict with leap.nvim
    keys = {
      close = '<Esc>',
      profile_sort = '<nop>',  -- Disable S keybinding
      profile_filter = '<nop>',
    },
  },
})
