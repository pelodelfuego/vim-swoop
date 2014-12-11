vim swoop
=========

Vim swoop is directly inspired from helm-swoop we can find in emacs.
It allow you to grep (multi buffer) and replace occurence while seeing the context of occurences.
On top of that, you can edit the swoop buffer and all changed occurences will be repercuted on origin files

Especially useful to refactor a name in multiple files and keep control on it.


How To
------
* Grep searched pattern in buffer
* A Temp Buffer will appear in a new window (The swoop Window)
* You can navigate with the swoop window and the display window will show the context

2 options here:
* Quit - (:q) to stop swoop and return at initial position
* Modify and save - (:w) wil replace all changed in the swoop buffer in the corresponding lines and files



Commnands
---------
* SwoopAllBuffer(pattern)  \<Leader\>gg
Will seek for the pattern in all buffers

* SwoopCurrentBuffer(pattern)  \<Leaded\>gc
Will seek in current buffer



Advertisement
-------------
This is under developpement and will be improved. It's just a poc (an useful one), please feel free to contribute if you think it worth it.

