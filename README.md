vim swoop
=========

Vim swoop is directly inspired from [helm-swoop](https://github.com/ShingoFukuyama/helm-swoop) we can find as emacs' plugin.

It allow you to grep and replace occurence while seeing the context of occurences.
You can edit the swoop buffer and all changed occurences will be repercuted on origin files

Especially useful to refactor a name in multiple files and keep control on it.


Usage
-----

Once you start swoop, you will be prompted for a pattern. Then a split scren contains the Swoop Buffer which contains all matched occurences.
As you navigate in the Swoop Buffer, the initial window will display the context of the match under the cursor.

You have 4 choices here:
* Continue navigation.
* Select Current Match (\<CR\>). Exit Swoop and go to the location of current match
* Edit Swoop Buffer (:w). The changes will be repercuted on all files by saving the Swoop Buffer
* Quit Swoop (:q). Exiting Swoop will bring you back to the initial buffer and position.


Commands
--------

* Swoop Current Buffer
```
noremap <Leader>gc :call SwoopCurrentBuffer()
```

* Swoop All Buffers
```
noremap <Leader>gg :call SwoopAllBuffer()
```

* Swoop Matching Buffers
```
noremap <Leader>gb :call SwoopMatchingBuffer()
```
You 'll be prompt for a regex to find which Buffers you want to search in.


Installation and dependancies
-----------------------------

Vim-Swoop is a pure vimscript plugin

### Pathogen (https://github.com/tpope/vim-pathogen)
```
git clone https://github.com/pelodelfuego/vim-swoop ~/.vim/bundle/vim-swoop
```


Known Bug and Issues
--------------------

* Swoop pattern highlight is case sentitive (the results are not)


Upcomming feature
-----------------
* Incremental Swoop
* Swoop Current selection


Credit
------
Special thanks to (Shingo Fukuyama)[https://github.com/ShingoFukuyama] for his amazing idea whicj has juste been ported to vim.

