" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Plugins
Plug 'preservim/nerdcommenter'
Plug 'easymotion/vim-easymotion'

" Initialize plugin system
call plug#end()

"=====================================================
" General settings
"=====================================================
syntax on
set number
set relativenumber
set expandtab
set shiftwidth=4
set tabstop=4
set smartindent
set clipboard=unnamedplus
set hidden

"=====================================================
" NERDCommenter configuration
"=====================================================
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1

"=====================================================
" EasyMotion configuration
"=====================================================
" Map <Leader><Leader>w to jump to word
nmap <Leader><Leader>w <Plug>(easymotion-w)
" Use case-insensitive search
let g:EasyMotion_smartcase = 1
" Use space as EasyMotion leader key
map <Leader> <Plug>(easymotion-prefix)

