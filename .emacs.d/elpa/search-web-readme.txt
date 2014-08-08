* Description

Post web search queries using `browse-url'.

There is useing style 2 way.
One is search-web-at-point.
This function is searching word on cursor.

And one is search-web-region.
This func is searching region text.


* Usage
Just put the code like below into your .emacs:

(require 'search-web)

Normal useing is M-x search-web-at-point or search-web-region.
But the way is not useability.

A usefull way is setting search engine and using command.

For example
CSS ref search
(define-key cssm-mode-map (kbd "C-c C-s r") (lambda () (interactive) (search-web-at-point "s")))
Press C-c s r post word on cursor sitepoint reference page at css-mode.

EmacsWiki search
(define-key emacs-lisp-mode-map (kbd "C-c C-s e") (lambda () (interactive) (search-web-at-point "ew")))

Google search at region
(define-key global-map (kbd "C-c C-s g") (lambda () (interactive) (search-web-region "g")))
