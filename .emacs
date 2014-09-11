; enable loading of custom packages/modules from ~/.emacs.d
(add-to-list 'load-path "~/.emacs.d")

; get in the common-lisp for some good functionality
(require 'cl)

; starting with version 24, emacs has its own package management system
; called ELPA (emacs lisp package archive) which can automate package
; management
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(require 'package)

(defvar all-cool-packages
  '(scala-mode2 ensime sbt-mode projectile markdown-mode clojure-mode flycheck dirtree)
  "The list of packages to ensure that they are installed whenever emacs is launched")

(defun all-cool-packages-installed-p ()
  ;; the #' instead of just a ' means that the passed symbol will always
  ;; be a function.
  (every #'package-installed-p all-cool-packages))

(defun install-the-cool-package (package)
  (unless (package-installed-p package)
    (package-install package)))

; If not all cool packages are installed, install the missing ones now
(unless (all-cool-packages-installed-p)
  (message "%s" "Refreshing the package database to check for new versions")
  (package-refresh-contents)
  (message "%s" "Refreshing packages done")
  (mapc #'install-the-cool-package all-cool-packages))

;; enable the dirtree mode. I am not sure why this is not enabled
;; by the package manager automatically
(require 'dirtree)

; save all backups inside the ~/.emacs.d/backups instead of having them sprinkled around1
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))


; Always use spaces instead of tabs
(setq-default indent-tabs-mode nil)

; when in a window system, display a better name for the frame, and
; disable the annoying blinking cursor
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (blink-cursor-mode -1))

; disable the splash screen and the startup echo area message
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

; auto-indent on pressing enter
(define-key global-map (kbd "RET") 'newline-and-indent)

; Change the 'yes or no' prompt with a 'y or n' prompt
(fset 'yes-or-no-p 'y-or-n-p)

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

; show matching parens and other characters
(show-paren-mode 1)
; Insert matching brackets, parens etc. automatically. Can be customized as well. Exactly
; which brackets are auto-closed depends on the current major-mode's syntax table
(electric-pair-mode 1)

; projectile introduces a concept of projects. Projects are identified by
; the presence of git, mercurial, bazaar, darcs repos, or by lein, maven
; sbt, rebar and bundler projects
(projectile-global-mode)

;; delete/replace selection when key is presses
(delete-selection-mode t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

; enable ensime mode whenever we are working with scala code (using scala-mode-2)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

; By default, emacs inserts tabs instead of spaces whenever it indents a region
; for ex. when using the indent-region command. Turn that off.
(setq-default indent-tabs-mode nil)

;; auto-asscociate .md and .markdown files to markdown-mode
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

; replace the normal text search with the regex search. Bind the original commands
; to something else
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

; instead of the default dabbrev-expand
(global-set-key (kbd "M-/") 'hippie-expand)

; instead of the default list-buffers. This is much better than the default.
(global-set-key (kbd "C-x C-b") 'ibuffer)

; bind M-x to something easier. Keep the original binding for now
(global-set-key (kbd "<f12>") 'execute-extended-command)

; Both M-left and C-left are bound to 'left-word. Similarly, M-right and
; C-right are bound to 'right-word. Bind the M-left and M-right to cycle
; between buffers
(global-set-key (kbd "M-<left>") 'previous-buffer)
(global-set-key (kbd "M-<right>") 'next-buffer)

; use shift-tab to decrease indent
(global-set-key (kbd "<backtab>") 'decrease-left-margin)
