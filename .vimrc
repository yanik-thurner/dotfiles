"===================="
"= General Settings ="
"===================="

" Line numbers
set number " Print the line number in front of each line.
set relativenumber " Show the line number relative to the line with the cursor in front of each line.

" Tabs
set tabstop=4 " Number of spaces that a <Tab> in the file counts for.
set shiftwidth=4 " Number of spaces to use for each step of (auto)indent.
set expandtab " In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
set autoindent " Copy indent from current line when starting a new line (typing <CR> in Insert mode or when using the "o" or "O" command).
set smartindent " Do smart autoindenting when starting a new line.

" Line Breaks
set wrap " When on, lines longer than the width of the window will wrap and displaying continues on the next line.
set breakindent " Every wrapped line will continue visually indented (same amount of space as the beginning of that line), thus preserving horizontal blocks of text.

" Folds
set foldlevel=1
set foldmethod=indent
set foldtext=FoldFormat()
function FoldFormat()
    let indent = substitute(matchstr(getline(v:foldstart), '^\s*'), '\t', repeat(' ', &tabstop), 'g') 
    let indent_dashed = substitute(indent, repeat(' ', v:foldlevel), v:folddashes, '')
    let start = substitute(getline(v:foldstart), '^\s*', '', '')
    let end = substitute(getline(v:foldend), '\s*', '', 'g')
    let left_text = indent_dashed .. start .. ' ... ' .. end .. ' '
    let right_text = printf("<[+%s lines]---", 1 + v:foldend - v:foldstart) .. winwidth(0)
    return left_text .. repeat(' ', winwidth(0) - len(left_text) - len(right_text) - 1) .. right_text
endfunction

" Search
set hlsearch " When there is a previous search pattern, highlight all its matches.
set incsearch " While typing a search command, show where the pattern, as it was typed so far, matches.
set ignorecase " Ignore case in search patterns, |cmdline-completion|, when searching in the tags file, and |expr-==|.
set smartcase " Override the 'ignorecase' option if the search pattern contains upper case characters.

" Misc
set clipboard=unnamedplus " Share clipboard with system

"===================="
"=== Key Bindings ==="
"===================="

" Movement
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>

" Text Manipulation
nnoremap x "_x
nnoremap X "_d
nnoremap XX "_dd


nnoremap == gg=G``

