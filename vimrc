" Keep vim from trying to be 100% vi compatible
set nocompatible

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

" Disable plugins which require vim 7.3
if v:version < '703'
    call add(g:pathogen_disabled, "syntastic")
endif

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
if exists("+showtabline")
    function MyTabLine()
        let s = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let s .= i . ')'
            let s .= ' %*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let file = bufname(buflist[winnr - 1])
            let file = fnamemodify(file, ':p:t')
            if file == ''
                let file = '[No Name]'
            endif
            let s .= file
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
endif

" Put buckups and swap files elsewhere
set backupdir=~/.tmp/
set directory=~/.tmp/

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
filetype plugin indent on
set number " Line numbers ftw!
nnoremap <F3> :set nonumber!<CR>

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
set clipboard=unnamed

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

" Block Arrow Keys
noremap  <Up> ""
noremap! <Up> <Esc>
noremap  <Down> ""
noremap! <Down> <Esc>
noremap  <Left> ""
noremap! <Left> <Esc>
noremap  <Right> ""
noremap! <Right> <Esc>
