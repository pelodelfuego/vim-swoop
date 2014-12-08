vim swoop
=========

Vim swoop is directly inspired from helm-swoop we can find in emacs.
It allow you to grep and replace occurence while seeing the context of occurences.
Especially useful to refactor a name in multiple files and keep control on it.


How To
------
* Grep searched pattern in buffer
* A Temp Buffer will appear
* You can navigate with the swoop window and the display window  will show the context
* Quit (:q) to stop at the position (for search)
* Modify and save (:w) to replace all changed line all swooped files



Commnands
---------
* SwoopAllBuffer(pattern)  <Leader>gg
Will seek for the pattern in all buffers

* SwoopCurrentBuffer(pattern)  <Leaded>gc
Will seek in all oppened buffers



Advertisement
-------------
This is under developpement and will be improved. It's just a poc (an useful one), please feel free to contribute if you think it worth it.

