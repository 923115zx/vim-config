""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"      FileName                    : .vimrc
"      Author                      : Zhao Xin
"      CreateTime                  : 2017-08-16 11:35:31 AM
"      VIM                         : ts=4, sw=4
"      LastModified                : 2017-09-20 22:17:47
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" +----------------------------------------------------------------------+
" |                          1. COMMON SETTINGS                          |
" +----------------------------------------------------------------------+
set vb t_vb=						" No annoying bell.
set nocompatible
set autoindent
set smartindent
set cindent
set textwidth=256					" Actually seems don't need to set this.
set ignorecase smartcase
set nu
set showmatch
set cursorline
set cursorcolumn
" Colorscheme solarized global variables.
let g:solarized_termcolors=&t_Co
let g:solarized_contrast="high"
let g:bgToggleKey = "<F6>"
let g:contraToggleKey = "<F7>"
:silent! nmap <silent> <unique> <F3> <F6>:AirlineRefresh<CR>
:silent! imap <unique> <silent> <F3> <F6><ESC>:AirlineRefresh<CR>
:silent! vmap <unique> <silent> <F3> <F6>:<C-u>AirlineRefresh<CR>gv
:silent! nmap <silent> <unique> <F4> <F7>:AirlineRefresh<CR>
:silent! imap <unique> <silent> <F4> <F7><ESC>:AirlineRefresh<CR>
:silent! vmap <unique> <silent> <F4> <F7>:<C-u>AirlineRefresh<CR>gv
if &t_Co > 2 || has("gui_running")
	syntax enable
	set hlsearch
	" Assume support 256 colors. Maybe it will cause bug. But whatever.
	set t_Co=256
	let g:solarized_termcolors=256
endif
" Want to change cursor shape to vertical bar when entering imode, and turn to
" block when return back to normal mode. Not work in xshell.
if &term =~ "xterm"
	let &t_SI = "\<ESC>]50;CursorShape=1\x7"
	let &t_EI = "\<ESC>]50;CursorShape=0\x7"
endif
"set nowrapscan
set nobackup
set nowritebackup
set background=dark
if has("gui_running")
	set background=light
	set noundofile
	" Windows gui settings.
	source $VIMRUNTIME/vimrc_example.vim
	"source $VIMRUNTIME/mswin.vim 		" Uncompatible with windows short cuts.
	behave mswin
	au GUIEnter * set t_vb=				" No annoying flash.
	autocmd GUIEnter * simalt ~x 		" Full screen when open gvim.
"	set guifont=Consolas:h12 			" self-define font in gui.
	set guifont=PTmono:h16 				" self-define font in gui.
	set guioptions=						" No menu, no scrollbar, no nothing.
"else
"	if isdirectory("~/.vim/doc")
"		silent helptags ~/.vim/doc/
"	endif
endif
set laststatus=2
"let &termencoding=&encoding
set encoding=utf-8
set fileencoding=utf-8
set fencs=utf-8,GB18030,ucs-bom,default,latin1
filetype plugin indent on
" Vim7.4 has no noinsert and noselect option for cot.
"set completeopt=menu,menuone,noinsert,preview
set completeopt=menu,longest,preview
set wildmode=list:longest,full		" Command line completion list.
set tabstop=4
set shiftwidth=4
set shiftround						" '<' and '>' operation will align to tab position.
set mps+=<:>
" Set fold with marker. zf--create fold. zo--open fold. zc--close fold.
" zM--Close all folds. zR--open all folds.
set foldmethod=marker
"set complete-=i 		" Slow down search speed in large project. Abandon cuz ycm.
let mapleader = "t"
set history=1000
set ruler
set viminfo='20,\"50
set backspace=indent,eol,start
set scrolloff=2
set splitright 			" When use :vsp, then new window appears on right.
"set paste				" This will destroy MyComplete effect, do not use.

" ctags usage. {{{
"ctags --c-kinds=+px --c++-kinds=+px --fields=+iafksS --extra=+qf -R /usr/include/* -f lib_tags
"ctags --c-kinds=+px --c++-kinds=+px --fields=+aiKSz --extra=+q -R
"ctags -I __THROW --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --c++-kinds=+p --fields=+S -R -f ~/.vim/systags /usr/include /usr/local/include
"ctags  -I __THROW  -I __THROWNL -I __attribute_pure__ -I __nonnull -I __attribute__ -R --c-kinds=+p --fields=+iaS --extra=+q --language-force=C /usr/include/
" }}}
" Keep finding tags file up till to /, the first encountered tags file will be used.
set tags=~/.lib_tags,tags;
set autochdir
set virtualedit=block	" Block visual select could select blank area.
set fileformats=unix,mac,dos
set noshowmode			" Cmdline shows no what mode now, airline could do that.

" Very funny feature, listchars. Copyed from Damian Conway's .vimrc.
set listchars=tab:⇒·,trail:␣,nbsp:~"
set nolist
" Actually I don't know what it matchs.
highlight InvisibleSpaces ctermfg=Black ctermbg=Black
call matchadd('InvisibleSpaces', '\s\+\%#', 100)

" +----------------------------------------------------------------------+
" |                         COMMON SETTINGS END                          |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                           2. EASY COMMENT                            |
" +----------------------------------------------------------------------+
" <C-p> is only available in c/c++(or java) files. It using to add
"  /*
" 	*
"	*/
" to current cursor position. Other filetype use it probably will cause a glitch.
:silent! nnoremap <unique> <Leader>p o/*<CR><BS><BS>*<CR>*/<ESC>kA<Space>
:silent! inoremap <unique> <C-p> /*<CR><BS><BS>*<CR>*/<Up><Space>
" Add single line comment to current position or start a commented new line.
" It support multiple filetypes. If encountered unknown filetype, it will do
" nothing but show errmsg.
:silent! nnoremap <unique> <expr> <leader>o <SID>WriteComment()
:silent! inoremap <unique> <silent> <C-o> <C-R>=<SID>WriteComment()<CR>

" Easy comment for line or lines. Works in nmode and vmode.
let g:comment_trigger="<Leader>/"
" Only works when one or more uncommented lines in selected lines. If all lines be
" commented, it wouldn't uncomment them.
let g:visual_uncomment_trigger="<Leader>r"

exe ":silent! nnoremap <unique> <silent> " . g:comment_trigger .
			\ " :call ToggleComment()<CR>"
exe ":silent! vnoremap <unique> <silent> " . g:comment_trigger .
			\ " :<C-u>call <SID>ToggleComments_visual()<CR>"
exe ":silent! vmap <unique> <silent> " . g:visual_uncomment_trigger .
			\ " :<C-u>call UncommentLines(line(\"'<\"), line(\"'>\"))<CR>"
:command! -range Cm <line1>,<line2>call <SID>ToggleComments_range()

let s:commentSymbols = {
				\ 'sh' 		: '#',
				\ 'python' 	: '#',
				\ 'perl' 	: '#',
				\ 'ruby' 	: '#',
				\ 'make' 	: '#',
				\ 'c' 		: '//',
				\ 'cpp' 	: '//',
				\ 'vim' 	: '"',
				\ 'java' 	: '//',
				\ 'lua' 	: '--',
				\ 'asm' 	: ';',
			\}

" Prepare to write a single line comment.
func! s:WriteComment()
	if &filetype == ''
		echom "Unknown filetype. Not support."
		return ''
	endif

	" Use commentstring instead of s:GetCommentString. Means use /*%s*/.
	let commentSymbol = &commentstring
	let commentSymbol_n = substitute(commentSymbol, '\S\zs%s', ' ', '')
	let commentInput = substitute(commentSymbol_n, '*\/\zs\s*$',
				\ "\<Left>\<Left>\<Left> ", '')
	if 'i' == mode()
		return commentInput
	endif
	" nmode.
	return 'o' . commentInput
endfunc

" Get commentstring for current filetype, replace '%s' to ' '.
func! s:GetCommentString()
	let cmstr = get(s:commentSymbols, &filetype, &commentstring)
	if cmstr == '/*%s*/'
		return '//'
	endif
	return substitute(cmstr, '%s', ' ', '')
endfunc

" Comment or uncomment current line.
func! ToggleComment()
	if &filetype == ''
		echom "Unknown filetype, not support."
		return
	endif
	" Do nothing to empty line.
	if s:IsEmptyLine()
		return
	endif

	let commentSymbol = s:GetCommentString()
	let sym_len = strlen(commentSymbol)
	let line_text = getline(".")
	let cur_col = col(".")

	" Where the comment symbol be writen in this line, 0 means not commented or empty line.
	let first_comment_pos = strlen(matchstr(line_text, '^\s*' . commentSymbol))
	if first_comment_pos == 0
		" Uncommented or empty line.
		exe "s\/\^\/" . s:EscapeStr(commentSymbol) . "\/g"
		let cur_col = sym_len == 1 ? cur_col+1 : cur_col+2
	else
		" Commented line. '- sym_len + 1' is because if commentSymbol is two chars long,
		" first_comment_pos will be the second char's col nr.
		call cursor(0, first_comment_pos - sym_len + 1)
		if sym_len == 1
			normal x
			let cur_col -= 1
		else
			normal xx
			let cur_col -= 2
		endif
	endif
	" Go back to original position before this function be called.
	call cursor(0, cur_col)
endfunc

let s:escapeChars = {
				\ '.' : '\.',
				\ '\' : '\\',
				\ '^' : '\^',
				\ '$' : '\$',
				\ '/' : '\/',
			\}

" Translate every char in str to escape format.
func! s:EscapeStr(str)
	let escapedStr = ""
	for index_ in range(strlen(a:str))
		let escapedStr .= get(s:escapeChars, a:str[index_], a:str[index_])
	endfor
	return escapedStr
endfunc

" Check if current line is commented. return 1 when it's commented, 0 uncommented.
" If current line is empty line(contains \s is not a empty line), function will
" return 0.
func! s:IsCommented(...)
	let line_text = a:0 == 0 ? getline('.') : getline(a:1)
	let COMMENTED_LINE = '^\s*' . s:GetCommentString() . '.*$'
	if line_text =~ COMMENTED_LINE
		return 1
	endif
	return 0
endfunc

" Comments lines from first_line to last_line.
func! s:ToggleComments(first_line, last_line)
	if &filetype == ''
		echo "Unknown filetype, not support."
		return ''
	endif
	" Find single line comment symbol for current filetype.
	let commentSymbol = s:GetCommentString()
	call cursor(a:first_line, 0)
	let first_line_text = getline('.')

	" Pattern for finding first uncommented or none-empty line.
	let becommented_pat = '^\(\s*\(' . s:EscapeStr(commentSymbol) . '\)\|$\)\@!'
	" Searching starts at a:first_line + 1. So need to separately check a:first_line.
	if match(first_line_text, becommented_pat) != -1
		let firstUncommentedLine = a:first_line
	else
		let firstUncommentedLine = search(becommented_pat, 'nW')
	endif

	" If no line that match the condition be found, search will return 0.
	if firstUncommentedLine == 0
		" To avoid that the a:last_line is the last line of current buffer.
		let firstUncommentedLine = line('$') + 1
	endif

	" Decide which function would be called and run the cmd for every line in range.
	let commentCmd = firstUncommentedLine > a:last_line ?
				\ 'call ToggleComment()' : 'call s:CommentCurLine()'
	for i in range(a:first_line, a:last_line)
		exe commentCmd
		normal j
	endfor
endfunc

" Check a line is empty or not. If no args offered, check current line, or check
" the line at the given line number.
func! s:IsEmptyLine(...)
	let line_text = a:0 == 0 ? getline('.') : getline(a:1)
	if line_text =~ '^\s*$'
		return 1
	endif
	return 0
endfunc

" Using for visual maps.
func! s:ToggleComments_visual()
	" Goto the last line of the last selected visual area and get line num.
	normal `>
	let last_line_nr = line(".")
	" Goto the first line of the last selected visual area and get line num.
	normal `<
	let first_line_nr = line(".")
	call s:ToggleComments(first_line_nr, last_line_nr)
endfunc

" Using for cmd line.
func! s:ToggleComments_range() range
	call s:ToggleComments(a:firstline, a:lastline)
endfunc

" Comment for current line, pass empty line.
func! s:CommentCurLine()
	if s:IsEmptyLine() || s:IsCommented()
		return
	endif
	let commentSymbol = s:GetCommentString()
	exe "s\/\^\/" . s:EscapeStr(commentSymbol) . "\/g"
endfunc

" Uncomment for a range.
func! UncommentLines(first_line, last_line)
	let commentSymbol = s:GetCommentString()
	for lnr in range(a:first_line, a:last_line)
		if !s:IsEmptyLine(lnr) && s:IsCommented(lnr)
			exe lnr . 's/^\s*\zs' . s:EscapeStr(commentSymbol) . '//g'
		endif
	endfor
endfunc

" +----------------------------------------------------------------------+
" |                           EASY COMMENT END                           |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                        3. C/C++ INPUT HELPER                         |
" +----------------------------------------------------------------------+
:silent! inoremap <unique> <C-F> __FUNCTION__
:silent! inoremap <unique> <C-L> __LINE__
:silent! nnoremap <unique> <silent> <Leader>n :call AddInclude(1)<CR>i
:silent! nnoremap <unique> <silent> <Leader>y :call AddInclude(0)<CR>a
" If pumvisible==1, <C-N> will be move selecting hi in popup menu, so we have to
" close popup menu first before we use <C-N>.
:silent! inoremap <unique> <silent> <C-N> <C-R>=AddInclude(1)<CR>
:silent! inoremap <unique> <silent> <C-Y> <C-R>=AddInclude(0)<CR>
" Add include header preprocess text.
func! AddInclude(sysheader)
	if &filetype != 'c' && &filetype != 'cpp'
		echo "Add include expr function only available in c/c++ file."
		return ''
	endif
	if a:sysheader
		let l:parenthese = "<>"
	else
		let l:parenthese = '""'
	endif
	let curmode = mode()
	if curmode == 'i' 		"Insert mode.
		if s:IsEmptyLine()
			return "#include " . l:parenthese . "\<Left>"
		else
			let addtext = "#include " . l:parenthese
			call append(line('.'), addtext)
			call cursor(line('.')+1, strlen(addtext))
			return ""
		endif
	elseif curmode == 'n' 	"Normal mode.
		if !a:sysheader
			let l:parenthese = '"'
		endif
		if s:IsEmptyLine()
			exe "normal i#include " . l:parenthese
			return
		else
			exe "normal o#include " . l:parenthese
			return ''
		endif
	endif
	echo "Add include only available in Insert, Normal modes."
endfunc
" +----------------------------------------------------------------------+
" |                        C/C++ INPUT HELPER END                        |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                         4. PARENTHESE ERASER                         |
" +----------------------------------------------------------------------+
" Delete parentheses.(also include <>[]{})
:silent! nnoremap <unique> <silent> <Leader>9 :call <SID>DeleteParentheses()<CR>

let s:parentheses = []
call add(s:parentheses, {'(' : ')', '[' : ']', '{' : '}', '<' : '>'})
call add(s:parentheses, {')' : '(', ']' : '[', '}' : '{', '>' : '<'})

" Delete whole line if only a:char in this line. Otherwise just delete a:char.
func! s:DeleteOneCharLine(char)
	if getline('.') =~ '^\s*' . a:char . '\s*$'
		normal dd
		return 1
	endif
	normal x
	return 0
endfunc

" Delete matched parentheses but remain the content between it. Cursor must on the
" parenthese when this function be called, either open or close.
func! s:DeleteParentheses()
	let cur_pos = getpos('.')
	let cur_line = cur_pos[1]
	let cur_col = cur_pos[2]
	let line_text = getline('.')
	let char_under_cursor = line_text[cur_pos[2]-1]

	" i==0 is open-parenthesis, i==1 is close-parenthesis.
	for i in range(2)
		if get(s:parentheses[i], char_under_cursor, 'n') != 'n'
			normal %
			if i==1 && cur_line==line('.')
				let cur_col -= 1
			endif
			let deletedLine = s:DeleteOneCharLine(get(s:parentheses[i], char_under_cursor))
			call cursor(deletedLine&&i==1 ? cur_line-1 : cur_line, cur_col)
			call s:DeleteOneCharLine(char_under_cursor)
		endif
	endfor
endfunc
" +----------------------------------------------------------------------+
" |                        PARENTHESE ERASER END                         |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                        5. TAB PAGE SHORTCUTS                         |
" +----------------------------------------------------------------------+
" Close all pages and windows, need buffers all be saved.
:silent! nnoremap <unique> <F2> :qall<CR>
" Clone cur windows's buffer to new tabpage.
:silent! nnoremap <unique> <Bar> :tab split<CR>
" Close current tabpage.
:silent! nnoremap <unique> <F5> :tabc<CR>
" Move focus from current tab page to another.
:silent! nnoremap <unique> - gT
:silent! nnoremap <unique> = gt
" Open a new tabpage, and use tag to code jump.
:silent! nmap <unique> <C-n>o <Bar>:tag <C-R>=expand("<cword>")<CR><CR>
" Move tabpage's position in tabpage menu.
:silent! nnoremap <unique> <F9> :tabm -1<CR>
:silent! nnoremap <unique> <F10> :tabm +1<CR>
" Close cur window and reopen the file of this window in new tabpage.
:silent! nnoremap <unique> \ :call <SID>Win2Tab()<CR>
func! s:Win2Tab()
	if winnr('$') == 1
		exe ":tab split"
	else
		let cur_file = expand("%")
		let pwd = getcwd()
		exe ":q"
		exe ":tabe"
		exe ":e " . pwd . "/" . cur_file
	endif
endfunc
"// If define another imap, following mappings will not work, cursor
"// arrows will become ABCD, I don't know why. Maybe need to change to
"// full installed vim or vim 8.0.
":inoremap <unique> <Up> <C-O><C-W>k<ESC>
":inoremap <unique> <Down> <C-O><C-W>j<ESC>
":inoremap <unique> <Left> <C-O><C-W>h<ESC>
":inoremap <unique> <Right> <C-O><C-W>l<ESC>

" +----------------------------------------------------------------------+
" |                        TAB PAGE SHORTCUTS END                        |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                      6. WINDOW ACCESS SHORTCUTS                      |
" +----------------------------------------------------------------------+
" Move focus between splited windows.
:silent! nnoremap <unique> <Space> <C-w><C-w>
" Block arrow keys, move focus accurately.
:silent! nnoremap <unique> <Up> <C-w>k
:silent! nnoremap <unique> <Down> <C-w>j
:silent! nnoremap <unique> <Left> <C-w>h
:silent! nnoremap <unique> <Right> <C-w>l
" Change windows' layout.
:silent! nnoremap <unique> <Leader><Up> <C-w>K
:silent! nnoremap <unique> <Leader><Down> <C-w>J
:silent! nnoremap <unique> <Leader><Left> <C-w>H
:silent! nnoremap <unique> <Leader><Right> <C-w>L
" Map some function keys to resize window size. map Home and End is not work to
" my keyboard. So map khome and home both.
:silent! nnoremap <unique> <Del> <C-w><
:silent! nnoremap <unique> <PageDown> <C-w>>
:silent! nnoremap <unique> <kHome> <C-w>+
:silent! nnoremap <unique> <kEnd> <C-w>-
:silent! nnoremap <unique> <Home> <C-w>+
:silent! nnoremap <unique> <End> <C-w>-
" Split window.
:silent! nnoremap <unique> <Leader>v <C-w>v
:silent! nnoremap <unique> <Leader>s <C-w>s
" Split current window, page-down window2, then scrollbind two windows. Used in
" code reading.
:silent! nnoremap <unique> <silent> <Leader>b :call <SID>Split_scb()<CR>
" Reverse operation to above. If not be split_scbed, Quit_scb will do nothing,
" but shows msg in command line.
:silent! nnoremap <unique> <silent> <Leader>c :call <SID>Quit_scb()<CR>

" Vertical split current window, adjust right window mapped file's part
" and set them scrollbind.
func! s:Split_scb()
	let cur_tab_win_count = winnr('$')
	if cur_tab_win_count > 1
		echo "More than 1 window in current tabpage, will not split and scrollbind."
		return
	endif
	exe "normal \<C-w>v"
	exe "normal \<C-w>\<C-w>\<C-f>"
	set scb
	exe "normal \<C-w>\<C-w>"
	set scb
endfunc

" Cancel split and scrollbind effect. Close the window that with earlier lines.
" XXX: For make sure the window layout, first I want to use screenrow to get there,
" 		but the screenrow and screencol are designed for debug, they are not proper
" 		in function. Then I choose to use winline, this function could get the
" 		screen line of the cursor in the window. I move cursor to line1, then check
" 		if winline() == 1. It's a little bit verbose, we also could use &lines and
" 		&columns to check if the window reach the screen's edge. Maybe there is
" 		better way to do it.
func! s:Quit_scb()
	if winnr('$') != 2
		echo "Must be called iff 2 windows in current tagpage."
		return
	endif
	let scloff = &scrolloff
	let win1_scb = &scrollbind
	let win1_file = expand("%:p")
	let win1_pos = getpos(".")
	normal H
	" Use screenrow to get current windows' first line in screen,
	" if it is horizontal split and in bottom, it would not be 1.
	let win1_screenTop = winline()
	let win1_lineTop = line('.')
	let win1_firstline = 1 + scloff
	if win1_lineTop == 1
		let win1_firstline = 1
	endif
	call setpos('.', win1_pos)
	" If windows1 is not scrollbinding, and horizontal splited, quit.
	if win1_scb==0 || win1_screenTop!=win1_firstline
		echo "Current tagpage windows are not be split_scbed. win1_scb=".win1_scb.", win1_screenTop=".win1_screenTop
		return
	endif
	exe "normal \<C-w>\<C-w>"
	let win2_scb = &scrollbind
	let win2_file = expand("%:p")
	let win2_pos = getpos(".")
	normal H
	let win2_screenTop = winline()
	let win2_lineTop = line('.')
	let win2_firstline = 1 + scloff
	if win2_lineTop == 1
		let win2_firstline = 1
	endif
	call setpos('.', win2_pos)
	" Check if window2 is not scrollbinding and if horizontal splited.
	if win2_scb==0 || win2_screenTop!=win2_firstline
		exe "normal \<C-w>\<C-w>"
		echo "Current tagpae windows are not be split_scbed."
		return
	endif
	" Check if two windows are loading same file.
	if win1_file !=# win2_file
		exe "normal \<C-w>\<C-w>"
		echo "Two windows loading different files."
		return
	endif
	" We don't check if two window is joined as nose to tail. I think
	" it's not necessary. But need to check which window's progress is
	" further, we keep the further one, close the other one.
	if win1_lineTop < win2_lineTop
		set noscb
		exe "normal \<C-w>o"
	else
		exe "normal \<C-w>\<C-w>\<C-w>o"
		set noscb
	endif
endfunc
" +----------------------------------------------------------------------+
" |                     WINDOW ACCESS SHORTCUTS END                      |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |               7. COMPARE (Has bug for now, 8.14.2017)                |
" +----------------------------------------------------------------------+
" Vertical split a file and diff.
:silent! nnoremap <unique> <Leader>e :call MakeDiff(0)<CR>
:silent! nnoremap <unique> <Leader>x :call MakeDiff(1)<CR>
:command! -nargs=? Sd :call Split_diff("<args>", 0)
:command! -nargs=? Sdh :call Split_diff("<args>", 1)

" Split window and diff them.
func! Split_diff(target, hex)
	let cur_tab_win_nr = winnr('$')
	if cur_tab_win_nr > 2
		echo "Too many windows on current tabpage. Should <=2."
		return
	endif
	if a:target == ""
		if cur_tab_win_nr == 2
			call MakeDiff(a:hex)
			return
		endif
		echo "No target specified only allowed in 2 windows on current tabpage."
		return
	endif
	if cur_tab_win_nr == 1
		exe ":vert diffsplit " . a:target
		let file_1 = expand('%')
		call Turn_hex(a:hex)
		exe "normal \<C-w>\<C-w>"
		if file_1 != expand('%')
			call Turn_hex(a:hex)
		endif
		exe "normal \<C-w>\<C-w>"
		return
	endif
	echo "Accept 1 argv 1 window, or 0 argv 2 windows on current tabpage."
endfunc

" When exactly 2 windows on current tabpage, vertical diff them.
func! MakeDiff(hex)
	let cur_tab_win_nr = winnr('$')
	if cur_tab_win_nr != 2
		echo "Expect exactly 2 windows on current tabpage. Now is " . cur_tab_win_nr
		return
	endif
	exe "normal \<C-w>h\<C-w>H"
	let file_1 = expand('%')
	call Turn_hex(a:hex)
	exe ":difft"
	exe "normal \<C-w>l"
	if file_1 != expand('%')
		Turn_hex(a:hex)
	endif
	exe ":difft"
	exe "normal \<C-w>h"
endfunc

" Turn content of current buffer to hex mode.
func! Turn_hex(hex)
	if a:hex
		exe ":%!xxd"
	endif
endfunc
" +----------------------------------------------------------------------+
" |                             COMPARE END                              |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                           8. AUTO BRACKET                            |
" +----------------------------------------------------------------------+

let s:pairedSymbols = {
				\ "["	 : "]",
				\ '('	 : ')',
				\ '<'	 : '>',
				\ '"'	 : '"',
				\ "'"	 : "'",
			\}

" Add maps for all keys in s:pairedSymbols.
func! s:RegisterPairedSymbols()
	for lsymbol in keys(s:pairedSymbols)
		if lsymbol != "'"
			exe "silent! inoremap <silent> " . lsymbol . " <C-R>=InputPairedSymbols('"
						\ . lsymbol . "')<CR>"
			exe "silent! vnoremap <silent> <Leader>" . lsymbol .
						\ " <ESC>:call AddParentheseForSelect('" . lsymbol . "')<CR>"
		else
			exe "silent! inoremap <silent> " . lsymbol . " <C-R>=InputPairedSymbols(\""
						\ . lsymbol . "\")<CR>"
			exe "silent! vnoremap <silent> <Leader>" . lsymbol .
						\ " <ESC>:call AddParentheseForSelect(\"" . lsymbol . "\")<CR>"
		endif
	endfor
	:silent! vnoremap <Leader>{ <ESC>:call AddParentheseForSelect('{')<CR>
endfunc
call s:RegisterPairedSymbols()

" Map <BS> to delete '()' or other empty parenthese. In theory, <C-h> == <BS>,
"  but actually mac doesn't recognize <C-h>, and rhel doesn't recognize <BS>.
let OS = system("\uname")
let BS = '<C-h>'
if OS =~ "Darwin.*"
	let BS = '<BS>'
endif
exe ":silent! inoremap <unique> <silent> <expr> " . BS . " DeletePairedSymbols()"
" Map <C-\> to delete right part of '()' or other empty parenthese.
:silent! inoremap <unique> <silent> <expr> <C-\> DeleteRedundandRightSymbol()

" template is not stl container name, but it followed <> too, so add it here.
let s:STLContainers = [
				\"array",
				\"list",
				\"deque",
				\"map",
				\"queue",
				\"set",
				\"stack",
				\"vector",
				\"template",
				\"lock_guard",
				\"unique_lock",
			\]

" Base on different input param, complete automatically.
func! InputPairedSymbols(lsymbol)
	" Unrecognized filetype will not complete.
	if get(s:commentSymbols, &filetype, '0') == '0'
		return a:lsymbol
	endif
	" Commented line will not complete. And the <TAB> still work, it is using to
	" avoid input double "'" in "someone's something".
	if s:IsCommented() == 1
		return a:lsymbol
	endif
	let rsymbol = s:pairedSymbols[a:lsymbol]
	if a:lsymbol != '<'
		return a:lsymbol . rsymbol . "\<Left>"
	endif
	" Only check stl containers here. Templates from other lib or selfdefined need
	" to add '>' manually, so I left complete > in MyComplete.
	let line_text = getline(".")
	let cur_col = col(".")
	let part_before_lsymbol = strpart(line_text, 0, cur_col-1)
	for key in s:STLContainers
		let keyword_len = strlen(key)
		let pbl_len = strlen(part_before_lsymbol)
		if keyword_len > pbl_len
			continue
		endif
		let matched_part = strpart(part_before_lsymbol, pbl_len-keyword_len, keyword_len)
		if matched_part != key
			continue
		endif
		return a:lsymbol . rsymbol . "\<Left>"
	endfor
	return a:lsymbol
endfunc

" Delete redundant symbol when paired symbols already haved.
func! DeleteRedundandRightSymbol()
	let line_text = getline(".")
	let cur_col = col(".")
	let lhsc = line_text[cur_col-2]
	let rhsc = line_text[cur_col-1]

	for [lsymbol, rsymbol] in items(s:pairedSymbols)
		if lhsc==lsymbol && rhsc==rsymbol
			return "\<Del>"
		endif
	endfor
endfunc

" Delete closed parenthese.
func! DeletePairedSymbols()
	let line_text = getline(".")
	let cur_col = col(".")
	let lhsc = line_text[cur_col-2]
	let rhsc = line_text[cur_col-1]
	for lsymbol in keys(s:pairedSymbols)
		let rsymbol = s:pairedSymbols[lsymbol]
		if lsymbol==lhsc && rsymbol==rhsc
			return "\<Del>\<BS>"
		endif
	endfor
	return "\<BS>"
endfunc

" Add parentheses for select area, a:symbol determin which kind brace to use.
func! AddParentheseForSelect(lsymbol)
	let rsymbol = get(s:pairedSymbols, a:lsymbol, '0')
	if a:lsymbol == '{'
		let rsymbol = '}'
	endif
	if a:lsymbol == ' '
		let rsymbol = ' '
	endif
	" Probably would't not happen.
	if rsymbol == '0'
		echo "Can't find paired close brace of [" . a:lsymbol . "]"
		return
	endif
	normal `>
	let last_line_nr = line(".")
	let last_col_nr = col(".")
	normal `<
	let first_line_nr = line(".")
	let first_col_nr = col(".")
	if a:lsymbol == '{'
		exe "normal O" . a:lsymbol
		call cursor(last_line_nr+1, last_col_nr)
		exe "normal o" . rsymbol
		return
	endif
	" Use setline here is because of imap about input paired symbols.
	" If use "normal " . a:lsymbol if will input (a:lsymbol.rsymbol).
	call InsertPartToLine(rsymbol, last_line_nr, last_col_nr+1)
	call InsertPartToLine(a:lsymbol, first_line_nr, first_col_nr)
endfunc

" param: 1. part want to insert. 2. line nr. 3. col nr.
func! InsertPartToLine(...)
	" Only accept 1 or 3 arguments.
	if a:0 == 0 || a:0 == 2
		return
	endif
	if a:0 == 1
		let line_text = getline(".")
		let col = col(".")
	else
		" a:0 >=3. Only use top 3 arguments.
		let line_text = getline(a:2)
		let col = a:3
	endif
	let lpart = strpart(line_text, 0, col-1)
	let rpart = strpart(line_text, col-1)
	call setline(a:2, lpart . a:1 . rpart)
endfunc

" +----------------------------------------------------------------------+
" |                           AUTO BRACKET END                           |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                     9. SEMI-AUTOMATIC COMPLETION                     |
" +----------------------------------------------------------------------+
let s:completions = []
func! s:AddCompletion(left, right, completion, restore)
	call add(s:completions, [a:left, a:right, a:completion, a:restore])
endfunc

let s:NONE = ""
"						left	right		completion		restore
"						====	======		=============	=======
call <SID>AddCompletion('{', 	'}',		"\<CR>\<ESC>O", 	0)
call <SID>AddCompletion('{', 	s:NONE,			'}', 			1)
call <SID>AddCompletion('\[', 	s:NONE,			"]", 			1)
call <SID>AddCompletion('(',	s:NONE,			")",			1)
call <SID>AddCompletion('<',	s:NONE,			'>',			1)
call <SID>AddCompletion("'",	s:NONE,			"'",			1)
call <SID>AddCompletion('"',	s:NONE,			'"',			1)
call <SID>AddCompletion('\p', 	"}",		"\<RIGHT>",			0)
call <SID>AddCompletion('\p', 	"]",		"\<RIGHT>",			0)
call <SID>AddCompletion('\p', 	')',		"\<RIGHT>",			0)
call <SID>AddCompletion('\p',	'>',		"\<RIGHT>",			0)
call <SID>AddCompletion('\p',	"'",		"\<RIGHT>",			0)
call <SID>AddCompletion('\p',	'"',		"\<RIGHT>",			0)

" I copyed SmartComplete from Damian Conway's article, but it has a bug...,
" I tried to fix it, failed. Than I change the content and write my own
" complete function, replace '%Nc' to compare the two characters in left
" slot and right slot next to current column.
func! MyComplete()
	" Popup menu is already opened, return CRTL-Y to choose the current highlight
	" option.
	let pum_access = ""
	if pumvisible()
		"return "\<C-N>"
		if !exists("g:loaded_youcompleteme")
			return "\<C-Y>\<TAB>"		" Ycm provides semantic complete, no need return CRTL-N here.
		endif
"		return "\<C-Y>\<ESC>a" 	 " Choose current highlighted option, and quit pupup menu.
		let pum_access = "\<C-Y>\<ESC>a"
	endif
	if BuildChunkFrame()
		return ""
	endif

	let cur_pos = getpos('.')
	let cur_col = cur_pos[2]
	let cur_line = cur_pos[1]
	let line_text = getline('.')

	" Before and after current col text in current line.
	"let lhs = strpart(line_text, 0, cur_col-1)
	"let rhs = strpart(line_text, cur_col-1)

	" %Nc is using for pattern match current column. Only works here.
	let position_pattern = '\%' . cur_col . 'c'
	" Detect if left side of current column are only spaces, return \t when yes.
	if line_text =~ '^\s*' . position_pattern
		return pum_access . "\<TAB>"
	endif

	" Very close to current column chars, left and right.
	let lhsc = line_text[cur_col-2]
	let rhsc = line_text[cur_col-1]
	" Pattern using for coming back to original position.
	let cursor_back = "\<C-O>:call setpos('.'," . string(cur_pos) . ")\<CR>"

	" Find matching cases in completions.
	for [lchar, rchar, replacement, ifback] in s:completions
		if lhsc=~lchar && rhsc==rchar
			" Code around bug in setpos() when used at EOL...
			if cur_col == strlen(line_text)+1 && strlen(replacement)==1
				let cursor_back = "\<LEFT>"
			endif
			" Check if class or struct definition, need to add ';' after '}' if yes.
			let chunkType = GetChunkType(cur_line)
			if lhsc=='{' && rhsc==s:NONE && chunkType!=""
				if chunkType == 'namespace'
				" Only c/c++ has namespace. so just use c style brick comment.
					let extra_comment = " \/\* namespace " . GetChunkName(cur_line) . " \*\/"
					return pum_access . replacement . extra_comment . (ifback ? cursor_back
								\. repeat("\<LEFT>", strlen(extra_comment)) : "")
				endif
				return pum_access . replacement . ';' . (ifback ? cursor_back . "\<LEFT>" : "")
			endif
			" Return self-define actions.
			return pum_access . replacement . (ifback ? cursor_back : "")
		endif
	endfor
	if lhsc =~ '\k' && !exists("g:loaded_youcompleteme")
		return pum_access . "\<C-N>"			" No ycm and lhs is alphanumeric, return CRTL-N
	else
		" If has ycm or other condition, still <TAB>
		return pum_access . "\<TAB>"
	endif
endfunc

let s:chunk_pattern_pairs = {
				\ 'namespace' 	: '^\s*namespace\s*',
				\ 'struct' 		: '^\s*struct\s*',
				\ 'class' 		: '^\s*class\s*',
				\ 'enum' 		: '^\s*enum\s*',
			\}

" Parse current line and previous line to get this chunk's type.
func! GetChunkType(lnr)
	for i in range(2)
		let line_text = getline(a:lnr-i)
		for [name, pattern] in items(s:chunk_pattern_pairs)
			if line_text =~ pattern . '.*'
				return name
			endif
		endfor
	endfor
	return ""
endfunc

" To fast write constructer, deconstructer, forbidden copy constructers.
func! BuildChunkFrame()
	" First, make sure current line is an empty line.
	if !s:IsEmptyLine()
		return
	endif
	let cur_linenr = line('.')
	" Second, check if next line only contains '};'
	let next_line_text = getline(cur_linenr+1)
	if next_line_text !~ "\s*};\s*"
		return
	endif
	" Third, check if class definition.
	for i in range(1, 2)
		let chunktype = GetChunkType(cur_linenr - i)
		if "class" == chunktype || "struct" == chunktype
			return FillFrameContent(GetIndentCount(cur_linenr - i) + 1, cur_linenr, GetChunkName(cur_linenr - i))
		endif
	endfor
endfunc

" Fill ChunkFrame content.
func! FillFrameContent(tabcount, cur_linenr, chunkname)
	let indents = s:Tabs(a:tabcount)
	call append(a:cur_linenr-1, indents . "\/\* Add members here. \*\/")
	call append(a:cur_linenr, indents)
	call append(a:cur_linenr+1, indents . a:chunkname . "(const " . a:chunkname . "&);")
	call append(a:cur_linenr+2, indents . a:chunkname . "& operator=(const " . a:chunkname ."&);")
	call append(a:cur_linenr+3, repeat("\t", a:tabcount-1) . "public:")
	call append(a:cur_linenr+4, indents . a:chunkname . "();")
	call append(a:cur_linenr+5, indents . "\~" . a:chunkname . "();")
	call append(a:cur_linenr+6, indents . "\/\* Add public interface here. \*\/")
	return 1
endfunc

" Get amount of indents that at beginning of line(lnr).
func! GetIndentCount(lnr)
	return strlen(matchstr(getline(a:lnr), '^\t*'))
endfunc

" Must be called in case of recent two lines contain 'namespace', 'class',
" 'struct' or 'enum'.
func! GetChunkName(lnr)
	for i in range(2)
		let line_text = getline(a:lnr-i)
		for chunk_pattern in values(s:chunk_pattern_pairs)
			let CHUNK_NAME = chunk_pattern . '\zs\S*'
			let chunkname = matchstr(line_text, CHUNK_NAME)
			if strlen(chunkname) != 0
				return chunkname
			endif
		endfor
	endfor
	return ''
endfunc

" <C-R> and <expr> both can call function in insert mode, but they have
" some small differences. When using <expr> to decorate map and rhs is
" function, then this function is not allowed to change buffer text.
":silent! inoremap <unique> <silent> <expr> <TAB> <SID>MyComplete()
:silent! inoremap <unique> <silent> <TAB> <C-R>=MyComplete()<CR>

" +----------------------------------------------------------------------+
" |                    SEMI-AUTOMATIC COMPLETION END                     |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                        10. PIECEMEAL FEATURES                        |
" +----------------------------------------------------------------------+
" (1) Into command-mode with ; instead of <S-;>.
:silent! nnoremap <unique> ; :
:silent! vnoremap <unique> ; :
" (2) Delete the part of current line before cursor, than into insert mode.
:silent! nnoremap <unique> T hv^s
" (3) Upper/Lower case switch.
"--Transfer recording ability to Q.
:silent! nnoremap <unique> Q q
" Toggle uppercase to lowercase or lowercase to uppercase.
:silent! nnoremap <unique> <expr> q ToupperOrTolower()
" Make current word to upper case.
:silent! nnoremap <unique> <Leader>q gUaw
func! ToupperOrTolower()
	let col = col(".")
	let line_text = getline(".")
	if line_text[col-1] =~ '\A'
		return "l"
	endif
	if line_text[col-1] =~ '\l'
		return "gUll"
	elseif line_text[col-1] =~ '\u'
		return "gull"
	endif
endfunc

" (4) Fast move cursor.
let g:jumpRange=9
exe ":silent! nnoremap <unique> <C-j> " . g:jumpRange . "j"
exe ":silent! vnoremap <unique> <C-j> " . g:jumpRange . "j"
exe ":silent! nnoremap <unique> <C-k> " . g:jumpRange . "k"
exe ":silent! vnoremap <unique> <C-k> " . g:jumpRange . "k"
" Move cursor to start and end of current line.
:silent! nnoremap <unique> <Leader>h ^
:silent! vnoremap <unique> <Leader>h ^
:silent! nnoremap <unique> <Leader>l $
" In visual mode, $ will come to \n, so here we go backward a little bit.
:silent! vnoremap <unique> <Leader>l $h

" Fast rolling the page. The key 'U' I never used, and the key 'D' is the same with
" 'x', use them to move up and down g:jumpRange lines.
exe ":silent! nnoremap <unique> U " . g:jumpRange . "<C-y>"
exe ":silent! nnoremap <unique> B " . g:jumpRange . "<C-e>"
exe ":silent! nnoremap <unique> U " . g:jumpRange . "<C-y>"
exe ":silent! nnoremap <unique> B " . g:jumpRange . "<C-e>"
let g:moveDenominator=6		" 3~10
let g:moveLeft="_"
let g:moveRight="+"
let g:find_="<C-g>" 		" use :f
exe ":silent! nnoremap <unique> " . g:find_ . " f_"
exe ":silent! vnoremap <unique> " . g:find_ . " f_"
exe ":silent! nnoremap <unique> <expr> <silent> ".g:moveLeft." MoveSwing(1)"
exe ":silent! vnoremap <unique> <expr> <silent> ".g:moveLeft." MoveSwing(1)"
exe ":silent! nnoremap <unique> <expr> <silent> ".g:moveRight." MoveSwing(0)"
exe ":silent! vnoremap <unique> <expr> <silent> ".g:moveRight." MoveSwing(0)"

" Move cursor to left or right 'g:moveDenominator' bytes.
func! MoveSwing(button)
	let toLeft = a:button
	if s:IsEmptyLine()
		if toLeft == 1
			return "\<Up>\<End>"
		endif
		return "\<Down>^"
	endif
	let moveDenominator = g:moveDenominator
	if g:moveDenominator > 10
		let moveDenominator = 10
	endif
	if g:moveDenominator < 3
		let moveDenominator = 3
	endif
	let pos = getpos('.')
	let line_len = col("$")
	let line_text = getline('.')
	for i in range(line_len)
		if line_text[i] !~ '\s'
			let start_col = i
			break
		endif
	endfor
	" -1 because line_len is length, start_col is col index.
	let contentlen = line_len - start_col - 1
	let move_dist = float2nr(contentlen / moveDenominator)

	if toLeft == 1
		if pos[2]-move_dist < start_col || move_dist == 0
			return "\<Up>\<End>"
		endif
		return move_dist . "\<Left>"
	else
		if pos[2]+move_dist > line_len-1 || move_dist == 0
			return "\<Down>^"
		endif
		return move_dist . "\<Right>"
	endif
endfunc

" (5) Trun off current searching word's  highlight. But not turn off hlsearch.
:silent! nnoremap <unique> <silent> <Leader>; :g/<C-R>=<SID>UnableToFind()<CR><CR>:echo <CR>
func! s:UnableToFind()
	let wontbefound = repeat('vimrc', 4)
	return wontbefound
endfunc
" (6) Omaps. Following 3 omaps works for parenthese. They work when left and right
" parenthese both in one line.

" Works only when cursor in parenthese, effect to the content int the "()".
:silent! onoremap <unique> p i(
" Works when cursor is at left out of a parenthese, effect to the content in the
" outer "()".
:silent! onoremap <unique> i :<C-u>normal! f(vi(<CR>
" Like above map, but effects to the content in the inner "()".
:silent! onoremap <unique> o :<C-u>normal! f)vi(<CR>

" (7) Delete word.
:silent! nnoremap <unique> <Leader>[ daw
:silent! nnoremap <unique> <Leader>] daW
" (8) Move cursor to middle of current line.
" Transfer function of 'm' that used to add bookmark to <Leader>m.
:silent! nnoremap <unique> <silent> <Leader>m m
:silent! nnoremap <unique> <silent> <expr> m <SID>MoveToMiddle()
:silent! vnoremap <unique> <silent> <expr> m <SID>MoveToMiddle()
" Move cursor to middle of line.
func! s:MoveToMiddle()
	if s:IsEmptyLine()
		return
	endif
	let cur_col = col('.')
	let line_len = col("$")
	let line_text = getline('.')
	for i in range(line_len)
		if line_text[i] !~ '\s'
			let line_start_col = i
			break
		endif
	endfor
	let line_middle = (line_len + line_start_col) / 2
	if line_middle > cur_col
		return line_middle-cur_col . "\<RIGHT>"
	elseif line_middle < cur_col
		return cur_col-line_middle . "\<LEFT>"
	else
		return ""
	endif
endfunc

" (9) Popup menu mappings.
":silent! inoremap <unique> <expr> <ESC> pumvisible() ? "\<C-E>" : "\<ESC>"
:silent! inoremap <unique> <expr> <ESC> pumvisible() ? "\<C-E>\<ESC>a" : "\<ESC>"
:silent! inoremap <unique> <expr> <CR>  pumvisible() ? "\<C-Y>\<ESC>a" : "\<CR>"
:silent! inoremap <unique> <expr> <C-j> pumvisible() ? "\<C-N>" : "\<Down>"
:silent! inoremap <unique> <expr> <C-k> pumvisible() ? "\<C-P>" : "\<Up>"

" (10) Add and delete spaces.
" Add a space to current cursor position's left and right respectively.
:silent! nnoremap <unique> <Leader><Space> i <ESC>la <ESC>h
" Add a space to selected area's left and right respectively.
:silent! vnoremap <unique> <Leader><Space> <ESC>:call AddParentheseForSelect(' ')<CR>
" Delete spaces at left and right of current cursor position. If no space, ignore.
:silent! nnoremap <unique> <silent> <Leader>r :call <SID>DeleteClosedSpaces()<CR>
func! s:DeleteClosedSpaces()
	let line_text = getline(".")
	let cur_col = col(".")
	let lhsc = line_text[cur_col-2]
	let rhsc = line_text[cur_col]
	if rhsc == ' '
		normal lxh
	endif
	if lhsc == ' '
		normal hx
	endif
endfunc

" (11) Delete empty lines.
:silent! vnoremap <unique> <silent> <C-a> <ESC>:call <SID>DeleteEmptyLines_visual()<CR>
:command! -range De <line1>,<line2>call <SID>DeleteEmptyLines_range()

func! s:DeleteEmptyLines_visual()
	normal `>
	let last_line_nr = line(".")
	normal `<
	let first_line_nr = line(".")
	exe first_line_nr . "," . last_line_nr . "g/^\s*$/d"
endfunc

func! s:DeleteEmptyLines_range() range
	exe a:firstline . "," . a:lastline . "g/^\s*$/d"
endfunc

" (12) Test function. Used to do some experiment.
func! GetCol()
"	let l:cur_pos = getpos('.')
"	let l:cur_col = cur_pos[2]
"	let l:cur_line_text = getline('.')
"	let l:cur_col_char = l:cur_line_text[l:cur_col]
"	let l:lhs = strpart(l:cur_line_text, 0, cur_col-1)
"	let l:rhs = strpart(l:cur_line_text, cur_col-1)
"	let l:lchar = l:cur_line_text[l:cur_col-2]
"	let l:rchar = l:cur_line_text[l:cur_col-1]

"	let screen_row = screenrow()
"	echo screen_row
"	let scb_ = &scrollbind
"	echo scb_
	echo "lines=".&lines.", columns=".&columns.", winheight=".winheight(0).", winwidth=".winwidth(0)

	"echo l:cur_col
	"echo l:cur_col_char
	"echo l:lhs
	"echo l:lchar
	"echo l:rchar
"	echo l:cur_line_text[l:cur_col]
endfunc
"nnoremap <expr> <Leader>g ":echom " . screenrow() . "\n"

" (12) Comment box. I wish this function could replace section title builder and
" 		title setter's job.
func! CommentBox(content, location, width, alignment, indent)
	" TODO: not finished.
endfunc

" (13) Section title builder.
:command! -nargs=1 St :call <SID>BuildSection("<args>")
func! s:BuildSection(headline)
	let sectionLen = 70
	let headline_len = strlen(a:headline)
	let rest_len1 = (sectionLen - headline_len) / 2
	let rest_len2 = rest_len1
	if headline_len % 2 == 1
		let rest_len2 += 1
	endif
	let comment_start = s:commentSymbols[&filetype] . " "
	let first_line = comment_start . "+" . repeat("-", sectionLen) . "+"
	let second_line = comment_start . "|" . repeat(" ", rest_len1) . a:headline .
				\repeat(" ", rest_len2) . "|"
	let third_line = comment_start . "+" . repeat("-", sectionLen) . "+"
	call append(line("."), first_line)
	normal j
	call append(line("."), second_line)
	normal j
	call append(line("."), third_line)
	normal j
endfunc

" (14) Move lines.
:silent! nnoremap <unique> <silent> <Leader>j :<C-u>exe 'move +' . v:count1<CR>
:silent! nnoremap <unique> <silent> <Leader>k :<C-u>exe 'move -1-' . v:count1<CR>
:silent! vnoremap <unique> <silent> <Leader>j :<C-u>call MoveLines(0, v:count1)<CR>
:silent! vnoremap <unique> <silent> <Leader>k :<C-u>call MoveLines(1, v:count1)<CR>
" Move block up or down.
func! MoveLines(up, count1)
	normal `>
	let last_line_nr = line('.')
	normal `<
	let first_line_nr = line('.')
	if a:up == 1
		let up_or_down = '-1-'
		let distance = a:count1
	else
		let up_or_down = '+'
		let distance = a:count1 + last_line_nr - first_line_nr
	endif
	exe first_line_nr . "," . last_line_nr . "move " . up_or_down . distance
endfunc

" (15) Cmode maps.
:silent! cnoremap <unique> <C-j> <Down>
:silent! cnoremap <unique> <C-k> <Up>

" (16) Set 'n' search forward, and 'N' search backward always.
:silent! nnoremap <unique> <expr> n 'Nn'[v:searchforward]
:silent! nnoremap <unique> <expr> N 'nN'[v:searchforward]

" (17) Vmode indent adjustment.
:silent! vnoremap <unique> < <gv
:silent! vnoremap <unique> > >gv

" (18) Restore cursor when openning file.
augroup vim_config
	au!
	autocmd BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") |
		\   exe "normal! g`\"" |
		\ endif
augroup end

" (19) Adding empty lines. Above and below.
:silent! nnoremap <unique> [<Space> :<C-u>put! =repeat(nr2char(10), v:count1)<CR>
:silent! nnoremap <unique> ]<Space> :<C-u>put =repeat(nr2char(10), v:count1)<CR>

" (20) Remove trailing chars before line end. Auto triggerred after buffer be loaded
" 		and before buffer be writen.
augroup vim_config
	" BufReadPost will need user to confirm, so just keep BufWritePre au.
"	autocmd BufReadPost * :%s/\s\+$//e
	autocmd BufWritePre *
		\ let cur_pos__ = getpos('.') |
		\ :%s/\s\+$//e |
		\ call setpos('.', cur_pos__)
augroup end

" (21) Shows up or hidden tabs, trails and non-breakable space. (see line99)
:silent! nnoremap <unique> <silent> zl :<C-u>call TriggerList()<CR>
" Show listchars or hidden them.
func! TriggerList()
	if &list==1
		set nolist
	else
		set list
	endif
endfunc

" (22) Swap v and <C-v>.
:silent! nnoremap v <C-v>
:silent! nnoremap <C-v> v

:silent! vnoremap v <C-v>
:silent! vnoremap <C-v> v

" +----------------------------------------------------------------------+
" |                        PIECEMEAL FEATURE END                         |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                        11. TITLE AUTO SETTER                         |
" +----------------------------------------------------------------------+
"autocmd!
" au events:
"	BufNewFile----starting to edit a non-existent file.
"	BufReadPre/BufReadPost-----starting to edit an existing file.
"	FilterReadPre/FilterReadPost-----read the temp file with filter output.
"	FileReadPre/FileReadPost----any other file read.
augroup vim_config
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
	autocmd BufNewFile * :call <SID>CreateFile()
"	autocmd BufNewFile *.asm :call BuildSandbox()
	autocmd BufWritePre,FileWritePre * let cur_pos__=getpos('.')
			\|call <SID>LastModFresh()|call setpos('.', cur_pos__)
augroup end
" Manually add title and write asm sandbox frame code.
:command! PP :call <SID>CreateFile()|call BuildSandbox()

func! s:Tabs(count)
	return repeat("\t", a:count)
endfunc

func! s:Spaces(count)
	return repeat(" ", a:count)
endfunc

func! s:CreateFile()
	let topping_len = 71
	let bottom_len = 71
	if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'java'
		let comm_simbol = '/'
		let comm_repeat = '*'
		let comm_prefix = ' '
		let bottom_len = 70
	elseif has_key(s:commentSymbols, &filetype)
		let comm_simbol = s:commentSymbols[&filetype]
		let comm_repeat = comm_simbol
		let comm_prefix = ''
		if &filetype == 'lua'
			let topping_len = 35
			let bottom_len = 35
		endif
	else
		return
	endif
	call append(line('$')-1, comm_simbol . repeat(comm_repeat, topping_len))
	call append(line('$')-1, comm_prefix . comm_repeat)
	call append(line('$')-1, comm_prefix . comm_repeat .
				\s:Spaces(6) . "FileName" . s:Spaces(20) . ": " . expand("%"))
	call append(line('$')-1, comm_prefix . comm_repeat .
				\s:Spaces(6) . "Author" . s:Spaces(22) .": Zhao Xin")
	call append(line('$')-1, comm_prefix . comm_repeat .
				\s:Spaces(6) . "CreateTime" . s:Spaces(18) . ": " . strftime("%Y-%m-%d %T"))
	call append(line('$')-1, comm_prefix . comm_repeat .
				\s:Spaces(6) . "VIM" . s:Spaces(25) . ": ts=" . &ts . ", sw=" . &sw)
	call append(line('$')-1, comm_prefix . comm_repeat .
				\s:Spaces(6) . "LastModified" . s:Spaces(16) . ": " . strftime("%Y-%m-%d %T"))
	call append(line('$')-1, comm_prefix . comm_repeat)
	call append(line('$')-1, comm_prefix . repeat(comm_repeat, bottom_len) . comm_simbol)
	" Specify bash for shell.
	if &filetype == 'sh'
		call append(line('$')-1, "")
		call append(line('$')-1, "\#!/bin/sh")
	endif
	" Add #ifndef #define for .h.
	let __profix = strpart(expand("%"), strchars(expand("%"))-2, 2)
	let __prename = strpart(expand("%"), 0, strchars(expand("%"))-2)
	if __profix == '.h'
		call append(line('$')-1, "")
		call append(line('$')-1, printf("#ifndef _%s_H_", toupper(__prename)))
		call append(line('$')-1, printf("#define _%s_H_", toupper(__prename)))
		call append(line('$')-1, "")
		call append(line('$')-1, "#endif	/* " . expand("%") . " */")
	endif
endfunc

" Write sandbox frame code for starting to edit a non-existent assemble source file.
func! BuildSandbox()
	if &filetype != 'asm'
		return
	endif
	call append(line('$')-1, "")
	call append(line('$')-1, "section .data")
	call append(line('$')-1, "section .text")
	call append(line('$')-1, "")
	call append(line('$')-1, "\tglobal _start")
	call append(line('$')-1, "")
	call append(line('$')-1, "_start:")
	call append(line('$')-1, "\tnop")
	call append(line('$')-1, "\t; Write your code between this two nop instructions.")
	call append(line('$')-1, "")
	call append(line('$')-1, "\tnop")
	call append(line('$')-1, "")
	call append(line('$')-1, "section .bss")
endfunc

" Every time write buffer to file, update the last modified time.
func! s:LastModFresh()
	if line("$") > 10
		let l = 10
	else
		let l = line("$")
	endif
	exe "silent 1," . l . "g/LastModified/s/LastModified.*/LastModified" . s:Spaces(16) . ": " .
				\ strftime("%Y-%m-%d %T")
endfunc
" +----------------------------------------------------------------------+
" |                        TITLE AUTO SETTER END                         |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                             12. PLUGINS                              |
" +----------------------------------------------------------------------+

" [----taglist----] (abandoned, replaced by tagbar) "{{{
"filetype plugin on
"let Tlist_Show_One_File = 1		" only show current file's tags.
"let Tlist_Exit_OnlyWindow = 1	" close file when only tags window left.
"let Tlist_Display_Prototype = 1
"let Tlist_Show_Menu = 1

"let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
" Toggle
":nnoremap <unique> <C-l> :Tlist<CR>
" Swith between tags window and text.
":nnoremap <unique> <C-m> <C-w><C-w>
":nnoremap <unique> <C-\> <C-w>j:q<CR>
" }}}

" [----winManager----] (abandoned, don't use much) {{{
"let g:winManagerWindowLayout='FileExplorer|TagBar'		"vim window layout.
"let g:persistentBehaviour=0 	"close vim if all editing files be closed.
"let g:winManagerWidth=45

":silent! nnoremap <unique> <Leader><TAB> :WMToggle<CR>
":silent! nnoremap <unique> <S-F11> :FirstExplorerWindow<CR>
":silent! nnoremap <unique> <S-F12> :BottomExplorerWindow<CR>
" }}}

" (1) tagbar
let g:tagbar_left = 1
let g:tagbar_width = 40
let g:tagbar_show_linenumber = 2

:silent! nnoremap <unique> <Leader><Tab> :TagbarOpen j<CR>
:silent! nnoremap <unique> <Leader>\ :TagbarToggle<CR>

" 's' Change soring order.
" 'o' Toggle fold.
" 'p' Jump tag but stay in tagbar.
" 'P' Open preview split window on the top of whole window.
" For more commands and infos, see :help tagbar

" (2) cscope (Actually cscope is not a plugin, a build-in component)
" build cscope shell "{{{
"absPath=`pwd`"/"
"find $absPath -name "*.h" -o -name "*.c" -o -name "*.hpp" -o -name "*.cc" -o -name "*.C" -o -name "*.cpp" > cscope.files
"cscope -bkq -i cscope.files
"rm -f cscope.files
" }}}
set cscopequickfix=s-,c-,d-,i-,t-,e-		"save result in quickfix buffer, not viminfo.

if has("cscope")
"	set csprg=/usr/local/bin/cscope
    set csto=1			"load tags file before cs db. default is 0, load cs db first.
    set cst				"set this means search tags and cs db both.
    set nocsverb		"if show msg on stdout when auto load cs db.
    set cspc=0			"show full path of search result, if 3, shows last three part of path, if 1, only file name.
    "add any database in current dir
    if filereadable("cscope.out")
		cs add cscope.out
		"else search cscope.out elsewhere
	else
		let cscope_file=findfile("cscope.out", ".;")
		"echo  cscope_file
		if !empty(cscope_file) && filereadable(cscope_file)
			exe "cs add " cscope_file
		endif
	endif
endif

"s:(symbol), g:(declare), d:(funs called by this func), c:(funcs that call this func),
"t:(string), e:(egrep), f:(file), i:(files include this file)
:silent! nnoremap <unique> <C-n>s :cs find s <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
:silent! nnoremap <unique> <C-n>g :cs find g <C-R>=expand("<cword>")<CR><CR>
:silent! nnoremap <unique> <C-n>d :cs find d <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
:silent! nnoremap <unique> <C-n>c :cs find c <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
:silent! nnoremap <unique> <C-n>t :cs find t <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
:silent! nnoremap <unique> <C-n>e :cs find e <C-R>=expand("<cword>")<CR><CR> :cw<CR><CR>
:silent! nnoremap <unique> <C-n>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
:silent! nnoremap <unique> <C-n>i :cs find i <C-R>=expand("<cfile>")<CR><CR> :cw<CR><CR>
":copen<CR><CR> could be added at last of above maps, to exchange output displayed
" to quickfix window. If use quickfix window, jump action will use different buffer
" with tags jump, so need use another command to utilize this function.
":nnoremap <unique> <F8> :cp<CR>
":nnoremap <unique> <F9> :cn<CR>
":nnoremap <unique> <F5> :b1<CR>

" (3) YouCompleteMe (Killer plugin)

let g:ycm_key_list_select_completion = []
let g:ycm_key_list_previous_completion = []
let g:ycm_confirm_extra_conf = 0
let g:ycm_goto_buffer_command = 'horizontal-split'
let g:ycm_warning_symbol = '->'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_always_populate_location_list = 1
let g:ycm_echo_current_diagnostic = 1
"let g:ycm_python_binary_path = '/usr/local/bin'
:silent! nnoremap <unique> <silent> <Leader>t :YcmCompleter GoToDefinitionElseDeclaration<CR>
":silent! nnoremap <unique> <silent> <Leader>f :YcmCompleter GoToInclude<CR>
":silent! nnoremap <unique> <silent> <Leader>g :YcmCompleter GoToDefinition<CR>
:silent! nnoremap <unique> <silent> <Leader>f :YcmCompleter FixIt<CR>
":silent! nnoremap <unique> <silent> <Leader>c :YcmCompleter GoToDeclaration<CR>
:silent! nnoremap <unique> <silent> <Leader>i :YcmDiags<CR>
":nnoremap <unique> <silent> <Leader>d :YcmCompleter GetType<CR>
":nnoremap <unique> <Leader>f :YcmCompleter YcmQuickFixOpened<CR>

" (4) Colorscheme
" TODO: Add airline refresh to background change and contrast change.
color modified_solarized

" [----Powerline----]	(Abandoned, replaced by airline.) {{{
"let g:Powerline_symbols = 'fancy'
" [----End Powerline----] }}}

" (5) Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_section_y = '%{strftime("%x %R %a")}'
let g:airline_section_x = ''
" Themes. After experiment,
" Good :
"	cool, lucius, base16, base16_bright, powerlineish, molokai, jellybeans
" Not Bad :
"	ubaryd, zenburn, aurora, papercolor, bubblegum, base16_summerfruit
let g:airline_theme='dark'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tagbar#enabled = 0

" +----------------------------------------------------------------------+
" |                             PLUGINS END                              |
" +----------------------------------------------------------------------+

" +----------------------------------------------------------------------+
" |                         13. ASSIGNALIGNMENT                          |
" +----------------------------------------------------------------------+
" Copy from Damian Conway's artical. Start to learn regex pattern.
func! AlignAssignments ()
	" Patterns needed to locate assignment operators...
	let ASSIGN_OP   = '[-+*/%|&]\?=\@<!=[=~]\@!'
	let ASSIGN_LINE = '^\(.\{-}\)\s*\(' . ASSIGN_OP . '\)\(.*\)$'

	" Locate block of code to be considered (same indentation, no blanks)...
	let indent_pat = '^' . matchstr(getline('.'), '^\s*') . '\S'
	let firstline  = search('^\%('. indent_pat . '\)\@!','bnW') + 1
	let lastline   = search('^\%('. indent_pat . '\)\@!', 'nW') - 1
	if lastline < 0
		let lastline = line('$')
	endif

	" Decompose lines at assignment operators...
	let lines = []
	for linetext in getline(firstline, lastline)
		let fields = matchlist(linetext, ASSIGN_LINE)
		if len(fields)
			call add(lines, {'lval':fields[1], 'op':fields[2], 'rval':fields[3]})
		else
			call add(lines, {'text':linetext,  'op':''                         })
		endif
	endfor

	" Determine maximal lengths of lvalue and operator...
	let op_lines = filter(copy(lines),'!empty(v:val.op)')
	let max_lval = max( map(copy(op_lines), 'strlen(v:val.lval)') ) + 1
	let max_op   = max( map(copy(op_lines), 'strlen(v:val.op)'  ) )

	" Recompose lines with operators at the maximum length...
	let linenum = firstline
	for line in lines
		let newline = empty(line.op)
					\ ? line.text
					\ : printf("%-*s%*s%s", max_lval, line.lval, max_op, line.op, line.rval)
		call setline(linenum, newline)
		let linenum += 1
	endfor
endfunc
:silent! nnoremap <unique> <silent> <Leader>= :call AlignAssignments()<CR>
" +----------------------------------------------------------------------+
" |                         ASSIGNALIGNMENT END                          |
" +----------------------------------------------------------------------+
" TODO:
" 1. Improve scb performence.
" 2. Seperate .h preaccess out from CreateFile(), and add it into TitleSetter as a new autocmd.
" 3. Add c++ testfile preparation cmd, in order to replace what mktest.sh do.
