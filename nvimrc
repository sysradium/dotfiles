let g:one_allow_italics = 1

set encoding=UTF-8

au FileType go nmap <leader>a :GoAlternate<cr>
au FileType go nmap <leader>i :GoInfo<cr>
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>d :GoDeclsDir<cr>
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
let g:go_metalinter_disabled = ['gosec', 'gas', 'ineffassign', 'structcheck', 'varcheck', 'unconvert']
let g:jedi#completions_enabled = 1
let g:jedi#force_py_version= "3"
let g:jedi#smart_auto_mappings = 1
let g:pymode_indent = 0
"let g:python3_host_skip_check = 1
"let g:python3_host_prog = '/usr/local/bin/python3'
"let g:python_host_prog = '/usr/local/bin/python3'
let g:tagbar_compact = 1
