; enable loading of custom packages/modules from ~/.emacs.d
(add-to-list 'load-path "~/.emacs.d")
1
; starting with version 24, emacs has its own package management system
; called ELPA (emacs lisp package archive) which can automate package
; management
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t))

; disable the splash screen and the startup echo area message
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

; auto-indent on pressing enter
(define-key global-map (kbd "RET") 'newline-and-indent)

; enable showing line numbers
(global-linum-mode 1)

(load-theme 'misterioso)

; do not show the toolbar
(tool-bar-mode -1)
; do not show the menu bar
;(menu-bar-mode -1)
; do now show the scroll bars
(scroll-bar-mode -1)

; enable IDO mode. IDO makes switching between buffers/files very easy by enabling partial matches
(ido-mode 1)
(setq ido-enable-flex-matching t)

; enable IDO for C-x C-f
(setq ido-everywhere t)


; When several buffers visit identically-named files, Emacs must give the buffers distinct
; names. The usual method for making buffer names unique adds ‘<2>’, ‘<3>’, etc. to the
; end of the buffer names (all but one of them). uniqify enables prepending dir names
; to identify each file/buffer uniquely.
; https://www.gnu.org/software/emacs/manual/html_node/emacs/Uniquify.html
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

; instead of the default dabbrev-expand
(global-set-key (kbd "M-/") 'hippie-expand)

; instead of the default list-buffers. This is much better than the default.
(global-set-key (kbd "C-x C-b") 'ibuffer)

; show matching parens and other characters
(show-paren-mode 1)
; Insert matching brackets, parens etc. automatically. Can be customized as well. Exactly
; which brackets are auto-closed depends on the current major-mode's syntax table
(electric-pair-mode 1)

; By default, emacs inserts tabs instead of spaces whenever it indents a region
; for ex. when using the indent-region command. Turn that off.
(setq-default indent-tabs-mode nil)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

; save all backups inside the ~/.emacs.d/backups instead of having them sprinkled around1
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))

; when in a window system, display a better name for the frame, and
; disable the annoying blinking cursor
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (blink-cursor-mode -1))
