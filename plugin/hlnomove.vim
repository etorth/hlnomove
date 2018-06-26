" to support search-and-no-move
" use space key to highlight pattern under the cursor
let g:word_under_cursor_hightlighting_list = []
function! ResetHighlightWordUnderCursorBySearchWord(search_word)
    call uniq(sort(g:word_under_cursor_hightlighting_list))

    if empty(a:search_word)
        return
    endif

    for index in range(0, len(g:word_under_cursor_hightlighting_list) - 1)
        if g:word_under_cursor_hightlighting_list[index] == a:search_word
            call remove(g:word_under_cursor_hightlighting_list, index)
            return
        endif
    endfor

    call add(g:word_under_cursor_hightlighting_list, a:search_word)
endfunction

function! BuildHightlightWordUnderCursorRegexp()
    call uniq(sort(g:word_under_cursor_hightlighting_list))

    if empty(g:word_under_cursor_hightlighting_list)
        return ''
    endif

    let l:search_regexp = '\<'.g:word_under_cursor_hightlighting_list[0].'\>'
    for index in range(1, len(g:word_under_cursor_hightlighting_list) - 1)
        let l:search_regexp = l:search_regexp.'\|\<'.g:word_under_cursor_hightlighting_list[index].'\>'
    endfor
    return l:search_regexp
endfunction

function! ToggleHighlightWordUnderCursor()
    if @/ != BuildHightlightWordUnderCursorRegexp()
        let g:word_under_cursor_hightlighting_list = []
    endif

    call ResetHighlightWordUnderCursorBySearchWord(expand('<cword>'))
    let l:search_regexp = BuildHightlightWordUnderCursorRegexp()

    let @/ = l:search_regexp
    if empty(l:search_regexp)
        return ":silent nohlsearch\<CR>"
    else
        return ":silent set hlsearch\<CR>"
    endif
endfunction
nnoremap <silent> <expr> <space> ToggleHighlightWordUnderCursor()
