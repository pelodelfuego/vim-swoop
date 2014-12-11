" TODO LIST
" <CR> goto and Quit
" Visual Mode
" Incremental Swoop
" Only one instance

highlight swoopMatch term=bold ctermbg=magenta guibg=magenta ctermfg=white guifg=white

function! s:extractLine()
    return [bufnr('%'), line('.'), getline('.')]
endfunction

function! s:initSwoop(bufList, pattern)
    if buflisted('swoopBuf') "not Working
        echo 'Swoop instance already Loaded'
        sleep 2
        return
    endif

    let s:beforeSwoopCurPos = getpos('.')
    let s:beforeSwoopBuffer = bufname('%')
    let orig_ft = &ft
    let results = []
    
    " fetch results in buffer list
    for currentBuffer in a:bufList
        call s:fetchPatternInBuffer(results, currentBuffer, a:pattern)
    endfor    
    
    " create swoop buffer
	execute ":match swoopMatch /".a:pattern."/"
    call s:createSwoopBuffer(results, orig_ft)
	execute ":match swoopMatch /".a:pattern."/"
    
endfunction

function s:fetchPatternInBuffer(results, buffer, pattern)
    execute "buffer ". a:buffer
    let currentBufferResults = []
        silent execute 'g/' . a:pattern . "/call add(currentBufferResults, join(s:extractLine(),'\t'))"

        if !empty(currentBufferResults)
            call add(a:results, "-------------------------------------------------")
            call add(a:results, bufname('%')) 
            call add(a:results, "-------------------------------------------------")
            call extend(a:results, currentBufferResults)
            call add(a:results, "") 
        endif
endfunction

function s:createSwoopBuffer(results, fileType)
    let s:displayWindow = bufwinnr(bufname('%'))
    silent bot split swoopBuf
    execute "setlocal filetype=".a:fileType
    let s:swoopWindow = bufwinnr(bufname('%'))
    call append(1, a:results)
    1d
endfunction

function! s:exitSwoop()
    silent bdelete! swoopBuf
    highlight clear swoopMatch
endfunction

function s:swoopQuit()
    call s:exitSwoop()
    execute s:displayWindow." wincmd w"
    execute "buffer ". s:beforeSwoopBuffer
    call setpos('.', s:beforeSwoopCurPos)
endfunction

function s:swoopSelect()
    echo 'select'
    sleep 1
    call s:exitSwoop()
endfunction

function! s:swoopSave ()
    execute "g/.*/call s:replaceSwoopLine(getline('.'))"
    execute ":1"
endfunction

function! s:gotoBufferLineKeepFocus(bufname, line)
    execute s:displayWindow." wincmd w"
    execute "buffer ". a:bufname
    execute ":".a:line
    execute "wincmd p"
endfunction

function! s:moveSwoopCursor()
    let swoopResultLine = split(getline('.'), '\t')
    if len(swoopResultLine) >= 3
        let bufname = swoopResultLine[0]
        let line = swoopResultLine[1]
        call s:gotoBufferLineKeepFocus(bufname, line)
    endif
endfunction

function! s:replaceSwoopLine(swoopLine)
    let swoopResultLine = split(a:swoopLine, '\t')
    let swoopBuffer = bufname('%')
    if len(swoopResultLine) >= 3
        let bufTarget = swoopResultLine[0]
        let lineTarget = swoopResultLine[1]
        let newLine = join(swoopResultLine[2:], '\t')

        execute "buffer ". bufTarget
        let oldLine = getline(lineTarget)
        if oldLine != newLine
            call setline(lineTarget, newLine)
        endif
    endif
    execute "buffer ". swoopBuffer
endfunction

function! s:findSwoopPattern()
    let pattern = input('Swoop: ')
    return pattern
endfunction

function! SwoopCurrentBuffer()
    let pattern = s:findSwoopPattern() 
    call s:initSwoop([bufnr('%')], pattern)
endfunction

function! SwoopAllBuffer()
    let pattern = s:findSwoopPattern()
    let allBuf = filter(range(1, bufnr('$')), 'buflisted(v:val)') 
    call s:initSwoop(allBuf, pattern)
endfunction

function! SwoopMatchingBuffer()
    "let pattern = s:findSwoopPattern()
    "let allBuf = filter(range(1, bufnr('$')), 'buflisted(v:val)') 
    
endfunction



noremap <Leader>gc :call SwoopCurrentBuffer()<CR>
noremap <Leader>gg :call SwoopAllBuffer()<CR>

noremap <buffer> <CR> :call SwoopSelect()<CR>

augroup swoopAutoCmd
    autocmd!  CursorMoved    swoopBuf      :call s:moveSwoopCursor()

    autocmd!  BufUnload    swoopBuf      :call s:swoopQuit()
    autocmd!  BufLeave    swoopBuf      :call s:swoopQuit()
    autocmd!  BufWriteCmd    swoopBuf      :call s:swoopSave()
augroup END
