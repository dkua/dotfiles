" Keep vim from trying to be 100% vi compatible
set nocompatible

" Turn Pathogen on
execute pathogen#infect()

" Tabs
set expandtab       " Use spaces instead of tabs
set smarttab        " Be smart about using tabs
set shiftwidth=4
set tabstop=2
set softtabstop=4
set autoindent      " Copy indent from current line to next upon pressing Enter
set history=1000

" Colours, fonts
syntax enable       " Enable syntax highlighting
se t_Co=256
let g:solarized_termcolors=256 
set background=dark
if !has('gui_running')
    let g:solarized_termtrans=1
endif
colorscheme solarized " Use Solarized theme

filetype on
filetype indent on  " Indent based on filetype
filetype plugin on
set number " Line numbers ftw!

" Use 256 colour palette if available
if &term =~ "xterm"
    set t_Co=256
endif

" Shift width by filetype
au BufEnter *.html,*.js,*.rb set shiftwidth=2

" Highlighting
au BufRead,BufNewFile *.twig set filetype=htmljinja
au BufRead,BufNewFile *.md set filetype=ghmarkdown

" Split windows
set splitbelow      " new windows open below the current window
set splitright      " new windows open to the right of the current window

" Insert newline below using Enter without entering insert mode
map <CR> o<Esc>k

" Remove the white underline for CursorLine
hi clear CursorLine

" Cursorline highlighted in normal mode; 
" Insert mode is exited after 15 seconds of inactivity
autocmd CursorMoved * set cursorline | hi CursorLine ctermbg=16
autocmd InsertEnter * let updaterestore=&updatetime | set updatetime=15000 | set nocursorline
autocmd InsertLeave * let &updatetime=updaterestore | set cursorline | hi CursorLine ctermbg=16

" Leave Insert mode if no key is pressed for 15 seconds in Insert mode
autocmd CursorHoldI * stopinsert 

" Jump to last known cursor position when editing a file
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Columns
if exists('+colorcolumn')
    set colorcolumn=80
    highlight ColorColumn ctermbg=darkgrey
else
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%81v.\+/
endif

" Menu
set wildmenu                                    " better command line completion
set wildmode=list:longest
set wildignore+=*.aux,*.out,*.toc               " LaTeX intermediate files
set wildignore+=*.pyc                           " python byte code
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg  " images
set wildignore+=.DS_STORE
set wildignore+=*.bak,*.o,*.e,*~                " misc

if exists ("&wildignorecase")
    set wildignorecase
endif

" Status line
set laststatus=2                        " always show the status line
set statusline+=\ #%n                   " buffer number
set statusline+=\ %<%F                  " full path, truncated
set statusline+=\ [%Y]                  " filetype, e.g. [python]
set statusline+=\ [%{&ff}]              " file format
set statusline+=\ %m                    " modified flag
set statusline+=\ %r                    " read-only flag
" last modified; takes up too much space
" set statusline+=\ (%{strftime(\"%c\",getftime(expand(\"%:p\")))}) 
set statusline+=%=                      " left/right separation point
set statusline+=\ \ %2l,                " current line number
set statusline+=%-5c                    " current column number
set statusline+=%p%%\ of\ %-6L          " total number of lines in buffer
set statusline+=\ [%03.3b][0x%02.2B]\   " ASCII and byte code of char under cursor
autocmd BufEnter * highlight StatusLine ctermbg=224 ctermfg=black
set statusline+=%{fugitive#statusline()}\ 

" When switching to a file, enter its directory
autocmd BufEnter * :lcd %:p:h

" Searching
set ignorecase      " ignore case when searching
set smartcase       " see :help smartcase
set hlsearch        " highlight search results
set incsearch       " highlight as you type search term

" Move between windows using ctrl + (standard line movement)
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

" Copying to / pasting from the system clipboard
vnoremap <c-y> :w !pbcopy<CR><CR>
nmap <c-p> :r !pbpaste<CR>

" These suffixes get lower priority when doing tab completion for filenames
" (usually files we are not likely to want to edit or read
set suffixes=.bak,.swp,.o,.info,.log,.idx,.out,.pyc

" Prevent auto-insert of linebreaks for long lines
set linebreak
set nolist
set textwidth=0
set wrapmargin=0

" Gundo Stuff
map <leader>g :GundoToggle<CR>

" NERDTree Stuff
autocmd vimenter * if !argc() | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Miscellaneous
set backspace=eol,start,indent " better backspacing
set ruler           " show current position
set cmdheight=2     " height of the command bar
set scrolloff=5     " 5 lines of context around the cursor
set magic           " for regular expressions
set lazyredraw      " do not redraw while running macros
set ttyfast         " improves redrawing
set title           " set title to value of 'titlestring' or 'filename'
set showcmd         " show (partial) command keys in the status line

if has("mouse")
    set mouse=a
endif
