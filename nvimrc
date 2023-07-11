function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

let g:ale_completion_enabled = 0
let g:one_allow_italics = 1

call plug#begin(expand('~/.nvim/plugged'))

set encoding=UTF-8

Plug 'Lokaltog/vim-easymotion'
"Plug 'Shougo/echodoc.vim'
Plug 'SirVer/ultisnips'
"Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'buoto/gotests-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'fisadev/vim-isort'
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
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-tree.lua'
Plug 'lewis6991/gitsigns.nvim'
"Plug 'windwp/nvim-autopairs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
Plug 'kdheepak/lazygit.nvim'
Plug 'j-hui/fidget.nvim'

call plug#end()

nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> [g :tabprevious<CR>
nmap <silent> ]g :tabnext<CR>
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)
nnoremap <leader>c :tabnew ~/.config/nvim/not-init.vim<cr>
nnoremap <leader>nt :NvimTreeToggle<cr>
"nnoremap <leader>b :CtrlPBuffer<cr>
"nnoremap <leader>p :CtrlPBufTag<cr>
"nnoremap <leader>s :CtrlPBufTagAll<cr>
nnoremap <leader>x :bd<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>gg :LazyGit<CR>

tnoremap <Esc> <C-\><C-n>
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"


" autocmd FileType * nested :call tagbar#autoopen(0)
" autocmd BufEnter * nested :call tagbar#autoopen(0)
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
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
let g:airline_theme = 'catppuccin'
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_go_golangci_lint_package = 1
let g:ale_lint_on_save = 1
let g:ale_go_golangci_lint_options = '--enable-all -D unused -D lll -D dupl -D gochecknoglobals --exclude-use-default --skip-files=".*\.pb\.go"'
let g:ale_linters = {'go': ['staticcheck', 'govet'], 'python': ['flake8', 'mypy', 'pylint', 'pyls']}
let g:ale_python_pylint_options = '--disable=missing-docstring,too-few-public-methods,line-too-long,unused-argument,invalid-name'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
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

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nmap <silent> gd <Plug>(coc-definition)

nnoremap <leader>g :Grepper<cr>
nmap <leader>rn <Plug>(coc-rename)

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction
