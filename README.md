vim swoop
=========

Vim swoop is directly inspired from [helm-swoop](https://github.com/ShingoFukuyama/helm-swoop) we can find as emacs' plugin.

It allows you to find and replace occurences in many buffers being aware of the context.

An animation means more than a boring speech...


![](https://github.com/pelodelfuego/vim-swoop/blob/dev/doc/images/moveSwoop.gif)

You can edit the swoopBuffer and the changes you applied will be save for all corresponding files by saving the buffer

Especially useful to refactor a name in multiple files and keep control on it...


Usage
-----

When you start vim-swoop (multi or single buffer mode) you get 2 windows.

First one contain context, the other is the swoop buffer. As you move the cursor to a match, the display windows will show the context.

From the swoop buffer, you can:
* Interactivly edit your search
* Navigate in results (and context) by moving the cursor
* Select current result.
*Exit Swoop and go to the location of current match when you press \<CR\>*
* Edit and save Swoop Buffer.
*The changes will be repercuted on all files by saving the Swoop Buffer*
* Quit Swoop.
*Exiting Swoop will bring you back to the initial buffer and position.*
* Toggle single and multi buffer mode

###single buffer mode
Start in insert mode, first line contains the search pattern.

As you type the pattern, results will interactivly be displayed bellow.

![](https://raw.githubusercontent.com/pelodelfuego/vim-swoop/dev/doc/images/singleModeScreenshot.png)


###multi buffer mode
Start in insert mode, first line contains the buffer pattern, no pattern means all buffers.

Buffer will be displayed interactivly bellow

![](https://raw.githubusercontent.com/pelodelfuego/vim-swoop/dev/doc/images/multiModeBufferPatternScreenshot.png)

Second line contains the search pattern just like in single buffer mode

![](https://raw.githubusercontent.com/pelodelfuego/vim-swoop/dev/doc/images/multiModeSwoopPatternScreenshot.png)

Commands and Configuration
--------

###Commands
Default mapping to use vim-swoop are:

* Swoop current buffer
```
nmap <Leader>l :call Swoop()<CR>
```

* Swoop multi buffers
```
nmap <Leader>ml :call SwoopMulti()<CR>
```


Those 2 action are also exposedby command line:

* Current buffer function
```
SwoopPattern(pattern)
```

* Multi buffer function

    For all buffer
```
SwoopMultiPattern(searchPattern)
```

    For specific buffer
```
SwoopMultiPattern(searchPattern, bufPattern)
```


###Configuration

* Disable quick regex mode

    By default, typing \<Space\> in the search pattern is replaced by ".*". You can get classic mode by:
```
let s:regexMode = 0
```

* Disable auto insert mode

    By default, you will start in insert mode, you can disable it by:
```
let s:autoInserMode = 0
```


Tips and Tricks
---------------
* Use CursorLine

    I strongly advise to highlight current line. It will help you to keep focus on the context of the current match.

* FileType and Session

    If you use [Vim-session](https://github.com/xolox/vim-session), be aware that it doesn't keep buffer filetype in memory.

    I'm working on this issue.

* Toggle mode

    You can toggle single and multi buffer mode, your Pattern will stay the same.

    Calling again a mode while your already in will reset the search pattern.

* Search in swoop buffer

    Since the context display depends of the cursor movement, you can lauch a search inside the search buffer

* Use last search

    When you start swoop (either the mode) and don't enter any pattern, search result will be your last search.

Installation and dependancies
-----------------------------

Vim-Swoop is a pure vimscript plugin, no other dependancies.


#### [Pathogen](https://github.com/tpope/vim-pathogen)
```
git clone https://github.com/pelodelfuego/vim-swoop ~/.vim/bundle/vim-swoop
```


Upcomming feature and improvement
-----------------
* Display empty buffer in display window when no context available (ie pattern or buffer name)
* Swoop Current selection
* Option to choose display windows place
* SmartCase search


Credit
------
Special thanks to [ Shingo Fukuyama ]( https://github.com/ShingoFukuyama ) for his amazing idea which has juste been ported to vim.

