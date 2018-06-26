" to support search-and-no-move
" use space key to highlight pattern under the cursor
let g:word_under_cursor_hightlighting_list = []
function! CreateSearchMultiWordRegexp()
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

function! ResetSearchMutliWordListOption()
    let @/ = CreateSearchMultiWordRegexp()
    silent set hlsearch
endfunction

function! ResetSearchMutliWordList()
    " @/ is not g:word_under_cursor_hightlighting_list
    " means user has searched something else, need to clean the list
    if @/ != CreateSearchMultiWordRegexp()
        let g:word_under_cursor_hightlighting_list = []
    endif

    " if current word is in the list
    " we double checked the word to un-highlight it
    let l:search_word = expand('<cword>')
    call uniq(sort(g:word_under_cursor_hightlighting_list))
    for index in range(0, len(g:word_under_cursor_hightlighting_list) - 1)
        if g:word_under_cursor_hightlighting_list[index] == l:search_word
            call remove(g:word_under_cursor_hightlighting_list, index)
            call ResetSearchMutliWordListOption()
            return
        endif
    endfor

    " not in the list
    " add a new word to the list
    call add(g:word_under_cursor_hightlighting_list, l:search_word)
    call ResetSearchMutliWordListOption()
endfunction
nnoremap <silent> <SPACE> :call ResetSearchMutliWordList()<CR>
