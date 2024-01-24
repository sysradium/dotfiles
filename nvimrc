function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

"let g:ale_completion_enabled = 0
let g:one_allow_italics = 1

set encoding=UTF-8

call plug#begin(expand('~/.nvim/plugged'))

"Plug 'Lokaltog/vim-easymotion'
"Plug 'Shougo/echodoc.vim'
Plug 'SirVer/ultisnips'
"Plug 'airblade/vim-gitgutter'
Plug 'buoto/gotests-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'fisadev/vim-isort'
Plug 'honza/vim-snippets'
Plug 'hynek/vim-python-pep8-indent'
Plug 'jodosha/vim-godebug'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mdempsky/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'mhinz/vim-grepper'
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
"Plug 'tweekmonster/django-plus.vim'
"Plug 'uarun/vim-protobuf'
"Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-tree.lua'
Plug 'lewis6991/gitsigns.nvim'
"Plug 'windwp/nvim-autopairs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
Plug 'kdheepak/lazygit.nvim'
Plug 'j-hui/fidget.nvim'

call plug#end()

au FileType go nmap <leader>a :GoAlternate<cr>
au FileType go nmap <leader>d :Dash<cr>
au FileType go nmap <leader>i :GoInfo<cr>
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>s :GoDeclsDir<cr>
au FileType go nmap <leader>t <Plug>(go-test)
au FileType sh setl cc=120 textwidth=120
au FileType yaml setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2
au FileType javascript.jsx setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

autocmd FileType qf wincmd J
autocmd FileType xhtml,typescript,html setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2

set tags+=doc/tags
match ErrorMsg '\s\+$'

colorscheme catppuccin-mocha " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
filetype plugin on
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
set backspace=indent,eol,start " enable backspace in INSERT mode when tryting to delete idented block
set cc=120
set completeopt+=noinsert
set completeopt-=preview
set ignorecase            " when searching
set mouse-=a
set noshowmode
set relativenumber number
set smartcase             " unless I use an uppercase character
set termguicolors
set textwidth=120
set shortmess+=c
set timeoutlen=1000 ttimeoutlen=0

" Close the documentation window when completion is done
" autocmd InsertLeave * if pumvisible() == 0 | pclose | endif
let g:UltiSnipsExpandTrigger="<c-s>"
let g:echodoc_enable_at_startup = 1
let g:go_gocode_propose_builtins = 0
let g:go_gocode_propose_source = 0
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types = 1
let g:go_info_mode = 'guru'
let g:go_metalinter_disabled = ['gosec', 'gas', 'ineffassign', 'structcheck', 'varcheck', 'unconvert']
let g:jedi#completions_enabled = 1
let g:jedi#force_py_version= "3"
let g:jedi#smart_auto_mappings = 1
let g:pymode_indent = 0
let g:python3_host_skip_check = 1
let g:python3_host_prog = '/usr/local/bin/python3'
let g:python_host_prog = '/usr/local/bin/python3'
let g:tagbar_compact = 1
let go_gocode_unimported_packages = 1
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0

nnoremap <leader>g :Grepper<cr>
