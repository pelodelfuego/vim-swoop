" TODO LIST
" <CR> goto and Quit
" Highlight pattern
" Visual Mode
" Incremental Swoop
" Only one instance

function! s:extractLine()
    return [bufnr('%'), line('.'), getline('.')]
endfunction

function! s:initSwoop(bufList, pattern)
    let s:beforeSwoopCurPos = getpos('.')
    let s:beforeSwoopBuffer = bufname('%')
    if buflisted('swoopBuf') "not Working
        echo 'Swoop instance already Loaded'
        return
    endif
    " init
    let orig_ft = &ft
    let results = []
    
    for currentBuffer in a:bufList
        execute "buffer ". currentBuffer
        call add(results, "-------------------------------------------------")
        call add(results, bufname('%')) 
        call add(results, "-------------------------------------------------")
        silent execute 'g/' . a:pattern . "/call add(results, join(s:extractLine(),'\t'))"
        call add(results, "") 
    endfor    

    " create swoop buffer
    let s:displayWindow = bufwinnr(bufname('%'))
    silent bot split swoopBuf
    execute "setlocal filetype=".orig_ft
    let s:swoopWindow = bufwinnr(bufname('%'))
    call append(1, results)
    1d
    
    "highlight rightMargin term=bold ctermfg=red guifg=red
	"execute ":match rightMargin /".a:pattern."/"
endfunction

function! s:quitSwoop()
    silent bdelete! swoopBuf
    execute s:displayWindow." wincmd w"
    execute "buffer ". s:beforeSwoopBuffer
    call setpos('.', s:beforeSwoopCurPos)
endfunction

function s:swoopSelect()
    echo 'select'
    sleep 1
    silent bdelete! swoopBuf
endfunction

function! s:saveSwoop ()
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
    "call s:initSwoop(allBuf, pattern)
endfunction

function! SwoopSelect()
    echo "select"
    sleep
endfunction


map <Leader>gc :call SwoopCurrentBuffer()<CR>
map <Leader>gg :call SwoopAllBuffer()<CR>

noremap <buffer> <CR> :call SwoopSelect()<CR>

autocmd!  CursorMoved    swoopBuf      :call s:moveSwoopCursor()

autocmd!  BufUnload    swoopBuf      :call s:quitSwoop()
autocmd!  BufLeave    swoopBuf      :call s:quitSwoop()
autocmd!  BufWriteCmd    swoopBuf      :call s:saveSwoop()
