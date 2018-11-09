function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.nvim/plugged')

Plug 'Lokaltog/vim-easymotion'
Plug 'Shougo/echodoc.vim'
Plug 'SirVer/ultisnips'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'buoto/gotests-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'fatih/vim-go'
Plug 'fisadev/vim-isort'
Plug 'honza/vim-snippets'
Plug 'hynek/vim-python-pep8-indent'
Plug 'jodosha/vim-godebug'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-github-dashboard.git'
Plug 'majutsushi/tagbar'
Plug 'mdempsky/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'mhinz/vim-grepper'
Plug 'rakr/vim-one'
Plug 'rizzatti/dash.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sebdah/vim-delve'
Plug 'sheerun/vim-polyglot'
Plug 'sickill/vim-monokai'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tweekmonster/django-plus.vim'
Plug 'uarun/vim-protobuf'
Plug 'w0rp/ale'

call plug#end()

nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> [g :tabprevious<CR>
nmap <silent> ]g :tabnext<CR>
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>c :tabnew ~/.config/nvim/init.vim<cr>
nnoremap <leader>nt :NERDTreeToggle<cr>
nnoremap <leader>p :CtrlPBufTag<cr>
nnoremap <leader>s :CtrlPBufTagAll<cr>
nnoremap <leader>x :bd<cr>
tnoremap <Esc> <C-\><C-n>
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"


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
colorscheme onedark
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

" Close the documentation window when completion is done
" autocmd InsertLeave * if pumvisible() == 0 | pclose | endif
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:UltiSnipsExpandTrigger="<c-s>"
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:ale_completion_enabled = 1
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_go_golangci_lint_options = '--fast'
let g:ale_go_golangci_lint_package = 1
let g:ale_linters = {'go': ['golangci-lint', 'golint', 'golangserver', 'govet', 'gofmt']}
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard | grep -v vendor/']
let g:echodoc_enable_at_startup = 1
let g:go_def_mode = 'godef'
let g:go_fmt_command = "goimports"
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
let g:one_allow_italics = 1
let g:onedark_terminal_italics = 1
let g:pymode_indent = 0
let g:python3_host_prog = '/Users/xenon/.pyenv/versions/neovim3/bin/python'
let g:python3_host_skip_check = 1
let g:python_host_prog = '/Users/xenon/.pyenv/versions/neovim3/bin/python'
let g:tagbar_compact = 1
let go_gocode_unimported_packages = 1
