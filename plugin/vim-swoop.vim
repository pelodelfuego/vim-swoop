
let s:regexMode = 1
let s:swoopSeparator = "\t"

let s:multiSwoop = -1

function! s:initSwoop()
    let s:beforeSwoopBuf = bufnr('%')
    let s:beforeSwoopPos =  getpos('.')
    let fileType = &ft

    let s:displayWin = bufwinnr('%')

    silent bot split swoopBuf
    execute "setlocal filetype=".fileType
    let s:swoopBuf = bufnr('%')

    highlight SwoopBufferLineHi term=bold ctermbg=lightgreen guibg=lightgreen 
    highlight SwoopPatternHi term=bold ctermbg=lightblue guibg=lightblue 

    imap <buffer> <silent> <CR> <Esc>
    nmap <buffer> <silent> <CR> :call SwoopSelect()<CR>
    
endfunction

function! s:exitSwoop()
    silent bdelete! swoopBuf
    call clearmatches()    
    let s:multiSwoop = -1
endfunction




function! Swoop()
    if s:multiSwoop == 0
        call setline(1, "")
    endif
    if s:multiSwoop == -1
        let s:multiSwoop = 0
        call s:initSwoop()
    endif
    if s:multiSwoop == 1
        let s:multiSwoop = 0
        let pattern = getline(2)
        call setline(1, pattern)
    endif

    execute ':1'
    startinsert
endfunction

function! SwoopMulti()
    if s:multiSwoop == 1
        call setline(2, "")
        execute ":2"
    endif
    if s:multiSwoop == -1
        let s:multiSwoop = 1
        call s:initSwoop()
        call append(1, [""])
        execute ":2"
    endif
    if s:multiSwoop == 0
        let s:multiSwoop = 1
        let pattern = getline(1)
        call setline(1, "")
        call append(1, [pattern])
        execute ':1'
    endif

    startinsert
endfunction

function! SwoopQuit()
    call s:exitSwoop()

    call clearmatches()
    execute s:displayWin." wincmd w"
    execute "buffer ". s:beforeSwoopBuf
    call setpos('.', s:beforeSwoopPos)
endfunction

function! SwoopSave()
    execute "g/.*/call s:setSwoopLine(s:getCurrentLineSwoopInfo())"
    execute ":1"
endfunction

function! SwoopSelect()
    if s:multiSwoop == 0
        if line('.') > 2
            call s:selectSwoopInfo()  
        else
            normal j
        endif
    else
        if line('.') > 3 
            call s:selectSwoopInfo()  
        else
            normal j
        endif
    endif
    normal zz
endfunction




function! s:cursorMoved()
    let beforeCursorMoved = getpos('.')
    let currentLine = beforeCursorMoved[1]

    if s:multiSwoop == 0
        if currentLine == 1
            call s:displaySwoopResult(beforeCursorMoved)
        else
            call s:displayCurrentContext()
        endif
    else
        if currentLine == 1
            call s:displaySwoopBuffer(beforeCursorMoved)
            let s:bufferLineList = [1]
        else
            if currentLine == 2
                call s:displaySwoopResult(beforeCursorMoved)
            else
                call s:displayCurrentContext()
            endif
        endif
    endif
    call s:displayHighlight()
endfunction










function! s:displaySwoopResult(beforeCursorMoved)
    let pattern = s:getSwoopPattern()
    let bufferList = s:getSwoopBufList() 

    let results = s:getSwoopResultsLine(bufferList, pattern)
    exec "buffer ". s:swoopBuf
    if s:multiSwoop == 0
        silent! exec "2,$d"
        call append(1, results)
    else
        silent! exec "3,$d"
        call append(2, results)
    endif
    call setpos('.', a:beforeCursorMoved)
endfunction

function! s:displaySwoopBuffer(beforeCursorMoved)
    exec "buffer ". s:swoopBuf
    silent! exec "3,$d"

    let swoopBufList = s:getSwoopBufList()
    let swoopBufStrList = map(copy(swoopBufList), 's:getBufferStr(v:val)') 

    call append(2, swoopBufStrList) 
    call setpos('.', a:beforeCursorMoved)
endfunction


function! s:displayCurrentContext()
    let swoopInfo = s:getCurrentLineSwoopInfo()
    if len(swoopInfo) >= 3
        let bufname = swoopInfo[0]
        let lineNumber = swoopInfo[1]
        let pattern = s:getSwoopPattern()

        exec s:displayWin." wincmd w"
        exec "buffer ". bufname
        let currentFileType = &ft
        exec ":".lineNumber
        normal zz
        
        execute "wincmd p"

    endif
endfunction

function! s:displayHighlight()
    let pattern = s:getSwoopPattern()

    call clearmatches()
    call matchadd("SwoopPatternHi", pattern)

    exec s:displayWin." wincmd w"
    call clearmatches()
    call matchadd("SwoopPatternHi", pattern)
    execute "wincmd p"

    call matchaddpos("SwoopBufferLineHi", s:bufferLineList)

endfunction








function! s:extractCurrentLineSwoopInfo()
    return join([bufnr('%'), line('.'), getline('.')], s:swoopSeparator)
endfunction

function! s:getCurrentLineSwoopInfo()
    return split(getline('.'), s:swoopSeparator)
endfunction

function! s:getBufferStr(bufNr)
    return join([a:bufNr, bufname(a:bufNr)], s:swoopSeparator)
endfunction

function! s:getSwoopResultsLine(bufferList, pattern)
    let results = []
    let s:bufferLineList = s:multiSwoop == 1 ? [1] : [] 
    for currentBuffer in a:bufferList
        execute "buffer ". currentBuffer 
        let currentBufferResults = [] 
        execute 'g/' . a:pattern . "/call add(currentBufferResults, s:extractCurrentLineSwoopInfo())" 
        if !empty(currentBufferResults)
            call add(results, bufname('%'))
            call add(s:bufferLineList, len(results) + 1 + s:multiSwoop)
            call extend(results, currentBufferResults)
            call add(results, "") 
        endif
    endfor
    return  results
endfunction




function! s:getSwoopPattern()
    if s:multiSwoop == 0
        let patternLine = getline(1)
    else
        let patternLine = getline(2)
    endif

    if empty(patternLine)
        return ''
    else
        let patternLine = patternLine.'\c'
    endif

    return s:regexMode == 1 ? join(split(patternLine), '.*')  : patternLine
endfunction

function! s:getSwoopBufList()
    if s:multiSwoop == 0
        let bufList = [s:beforeSwoopBuf]
    else
        let bufList = s:getAllBuffer()
        let bufPattern =  s:regexMode == 1 ? join(split(getline(1)), '.*') : getline(1)

        call filter(bufList, 's:getBufferStr(v:val) =~? bufPattern')
    endif
    return bufList
endfunction

function! s:getAllBuffer()
    let allBuf = filter(range(1, bufnr('$')), 'buflisted(v:val)') 
    let swoopIndex = index(allBuf, s:swoopBuf)
    call remove(allBuf, swoopIndex)
    return allBuf
endfunction





function! s:setSwoopLine(swoopInfo)
    if len(a:swoopInfo) >= 3
        let bufTarget = a:swoopInfo[0]
        let lineTarget = a:swoopInfo[1]
        let newLine = join(a:swoopInfo[2:], s:swoopSeparator)

        execute "buffer ". bufTarget
        let oldLine = getline(lineTarget)

        if oldLine != newLine
            call setline(lineTarget, newLine)
        endif

    endif
    execute "buffer ". s:swoopBuf
endfunction


function! s:selectSwoopInfo()
    let swoopInfo = s:getCurrentLineSwoopInfo()
    call s:exitSwoop()

    if len(swoopInfo) >= 3
        execute "buffer ". swoopInfo[0]
        execute ":".swoopInfo[1]
    endif
endfunction



nmap <Leader>l :call Swoop()<CR>
nmap <Leader>ml :call SwoopMulti()<CR>

augroup swoopAutoCmd
    autocmd!    CursorMovedI   swoopBuf   :call   s:cursorMoved()
    autocmd!    CursorMoved    swoopBuf    :call   s:cursorMoved()

    autocmd!    BufWrite    swoopBuf    :call   SwoopSave()
    autocmd!    BufLeave   swoopBuf   :call    SwoopQuit() 
augroup END
