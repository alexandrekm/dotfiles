-- Plugin list for lazy.nvim
-- Each entry is a table describing a plugin. Keep this file lean and move heavy configs
-- to `plugins/configs/*.lua` to keep startup fast.
local plugins = {
  -- NERDCommenter (from .nvimrc)
  {
    'preservim/nerdcommenter',
    config = function() require('plugins.configs.nerdcommenter') end,
  },

  -- EasyMotion (from .nvimrc)
  {
    'easymotion/vim-easymotion',
    config = function() require('plugins.configs.easymotion') end,
  },
}

require('lazy').setup(plugins)
