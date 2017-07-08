noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>

if &term =~ '256color'
	set t_ut=
endif

set nocompatible              " be iMproved, required
filetype off                  " required
au BufRead,BufNewFile *.yml set filetype=ansible

set rtp+=~/.fzf
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'UltiSnips'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
"Plugin 'tpope/vim-commentary'
Plugin 'Syntastic'
Plugin 'ctrlp.vim'
Plugin 'honza/vim-snippets'
Plugin 'fugitive.vim'
Plugin 'vim-vagrant'
Plugin 'tpope/vim-unimpaired'
Plugin 'Valloric/YouCompleteMe'
Plugin 'davidhalter/jedi-vim'
" Plugin 'lambdalisue/vim-pyenv'
Plugin 'Tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'airblade/vim-gitgutter'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'takac/vim-hardtime'
Plugin 'chase/vim-ansible-yaml'
"Plugin 'cespare/vim-toml'
"Plugin 'jmcomets/vim-pony'
Plugin 'majutsushi/tagbar'
"Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-easytags'
" Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'tpope/vim-obsession'
Plugin 'junegunn/fzf'
Plugin 'rking/ag.vim'
" Plugin 'rstacruz/vim-closer'
Plugin 'crusoexia/vim-monokai'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'fatih/vim-go'
Plugin 'fisadev/vim-isort'

call vundle#end()            " required
filetype plugin indent on    " required

" Store swap files in one directory to avoid them from being added to the git
" repo
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set backupcopy=yes

let g:tmuxline_preset = 'tmux'

set laststatus=2
set relativenumber number
set cc=80
set textwidth=80
syntax on

let g:hardtime_default_on = 1
let g:hardtime_showmsg = 1
let g:hardtime_maxcount = 3
let g:hardtime_ignore_quickfix = 1
let g:list_of_insert_keys = []


nmap <silent> [g :tabprevious<CR>
nmap <silent> ]g :tabnext<CR>
cmap Q q
cmap W w
nnoremap <leader>p :CtrlPTag<cr>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc     " MacOSX/Linux

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|pyc)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }


match ErrorMsg '\s\+$'

set backspace=indent,eol,start " enable backspace in INSERT mode when tryting to delete idented block
set ignorecase            " when searching
set smartcase             " unless I use an uppercase character

" nmap <silent> t <Plug>(easymotion-t2)
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)

let g:airline_theme="powerlineish"
set ttimeoutlen=50
let g:airline_powerline_fonts = 1

" Syntastic
let g:syntastic_python_flake8_args='--ignore=E501,E126,E128'
let g:syntastic_python_pylint_args='-d too-few-public-methods,line-too-long,missing-docstring'
let g:syntastic_aggregate_errors = 1
" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion = 1
" YCM conflicts with the UltiSnips <tab> expand. Fixing by rebinding ultisnips expoand key
let g:UltiSnipsExpandTrigger="<c-j>"
" Fix YCM popup window color.
highlight Pmenu ctermbg=DarkGray

" jedi-vim {
let g:jedi#auto_vim_configuration = 0
" let g:jedi#popup_on_dot = 0
" let g:jedi#popup_select_first = 0
" let g:jedi#completions_enabled = 0
" let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = 2

let g:jedi#goto_assignments_command = "<leader>pa"
let g:jedi#goto_definitions_command = "<leader>pd"
let g:jedi#documentation_command = "<leader>pk"
let g:jedi#usages_command = "<leader>pu"
let g:jedi#rename_command = "<leader>pr"

if jedi#init_python()
    function! s:jedi_auto_force_py_version() abort
        let major_version = pyenv#python#get_internal_major_version()
        call jedi#force_py_version(major_version)
    endfunction
    augroup vim-pyenv-custom-augroup
        au! *
        au User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
        au User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    augroup END
endif
" }
"

let g:ansible_options = {'ignore_blank_lines': 0}

nmap <F8> :TagbarToggle<CR>
colorscheme monokai

""" GO
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
