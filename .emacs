; get in the common-lisp for some good functionality
(require 'cl)

; starting with version 24, emacs has its own package management system
; called ELPA (emacs lisp package archive) which can automate package
; management
(package-initialize)
(add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(require 'package)

(defvar required-packages
  '(scala-mode2
    ensime
    sbt-mode
    projectile
    markdown-mode
    clojure-mode
    cider
    company
    ess
    go-mode
    elixir-mode
    erlang
    slime
    flycheck
    dirtree
    sass-mode
    scss-mode
    goto-last-change
    rainbow-delimiters
    cyberpunk-theme
    material-theme
    color-theme-sanityinc-tomorrow)
  "The list of packages to ensure that they are installed whenever emacs is launched")

(defun all-required-packages-installed-p ()
  ;; the #' instead of just a ' means that the passed symbol will always
  ;; be a function.
  (every #'package-installed-p required-packages))

(defun install-package (package)
  (unless (package-installed-p package)
    (package-install package)))

(unless (all-required-packages-installed-p)
  (message "%s" "Refreshing the package database to check for new versions")
  (package-refresh-contents)
  (message "%s" "Refreshing packages done")
  (mapc #'install-package required-packages))

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
  (blink-cursor-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1))

; disable the splash screen and the startup echo area message
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

; Change the 'yes or no' prompt with a 'y or n' prompt
(fset 'yes-or-no-p 'y-or-n-p)

; enable showing line numbers
(global-linum-mode 1)

; load the named theme. The seconds arg ensures that emacs doesn't ask you
; any questions about whether you want to load the executable code from the
; theme or not.
(load-theme 'material t)


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
; which brackets are auto-closed depends on the current major-mode's syntax table.
(electric-pair-mode 1)

; projectile introduces a concept of projects. Projects are identified by
; the presence of git, mercurial, bazaar, darcs repos, or by lein, maven
; sbt, rebar and bundler projects
(projectile-global-mode)

;; delete/replace selection when a key is pressed
(delete-selection-mode t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; Forces the messages to 0, and kills the *Messages* buffer, disabling it
;; on startup.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

; enable ensime mode whenever we are working with scala code (using scala-mode-2)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(add-hook 'java-mode-hook 'ensime-scala-mode-hook)

; enable spell-check and auto-fill mode to text modes
(add-hook 'markdown-mode-hook 'auto-fill-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

; enable rainbow delimiters for programming language modes
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; turn on eldoc mode for cider
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(add-hook 'cider-repl-mode-hook 'company-mode)
(add-hook 'cider-mode-hook 'company-mode)

; sub-word (camel-case) navigation
(add-hook 'text-mode-hook 'subword-mode)
(add-hook 'prog-mode-hook 'subword-mode)

(add-hook 'html-mode-hook
    (lambda ()
      ;; Default indentation is usually 2 spaces, changing to 4.
      (set (make-local-variable 'sgml-basic-offset) 4)))

; associate java files with scala mode
(add-to-list 'auto-mode-alist '("\\.java\\'" . scala-mode))

; By default, emacs inserts tabs instead of spaces whenever it indents a region
; for ex. when using the indent-region command. Turn that off.
(setq-default indent-tabs-mode nil)

; hide special buffers generated by clojure's nrepl
(setq nrepl-hide-special-buffers t)

;; auto-asscociate .md and .markdown files to markdown-mode
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Erlang setup
(setq erlang-root-dir "/usr/lib/erlang")
(setq exec-path (cons "/usr/lib/erlang/bin" exec-path))
(require 'erlang-start)
;; end erlang setup

;; some settings for common-lisp
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
;; Set this to whichever lisp executable you have installed. Currently,
;; I have both clisp and sbcl. If your lisp executble is named 'lisp',
;; you won't need this. So, another way of doing this would be to execute
;; ln -s /usr/bin/clisp /usr/bin/lisp  # or
;; ln -s /usr/bin/sbcl /usr/bin/lisp
;; clisp has better repl.
(setq inferior-lisp-program "clisp")
; (setq inferior-lisp-program "sbcl")

;;;; Custom Functions

(defun kill-this-buffer-and-close-window ()
  "Kill this buffer, and if there are multiple open windows, close this window as well"
  (interactive)
  (if (one-window-p)           ; if there is only one window open
      (kill-this-buffer)       ; then kill this buffer,
    (kill-buffer-and-window))) ; otherwise, kill the buffer and close its window as well

(defun kill-other-buffer-and-close-window ()
  (interactive)
  (other-window 1)
  (kill-this-buffer-and-close-window))

(defun open-or-goto-terminal-buffer ()
  "If an ansi-term buffer exists, switch to it. If it doesn't create a new one and switch."
  (interactive)
  (if (not (get-buffer "*ansi-term*"))
      (ansi-term (getenv "SHELL"))
    (switch-to-buffer "*ansi-term*")))

;;;; Key Bindings

; auto-indent on pressing enter
(define-key global-map (kbd "RET") 'newline-and-indent)

; use Ctrl+F4 to kill current buffer, and close its window if there are multiple
; open windows (similar to closing a tab)
(global-set-key (kbd "C-<f4>") 'kill-this-buffer-and-close-window)

; Use Ctrl+Shift+F4 to kill the buffer in the next window. If there are multiple
; windows open, close the window of that other buffer as well.
(global-set-key (kbd "C-S-<f4>") 'kill-other-buffer-and-close-window)

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

; use a custom command to switch to the terminal buffer (calls custom func)
(global-set-key (kbd "C-c t") 'open-or-goto-terminal-buffer)

; Set shortcut for jumping to the last change location. C-q was originally
; bound to 'quoted-insert
(global-set-key (kbd "C-q") 'goto-last-change)

; kill buffers without confirmation if they are not modified
(global-set-key (kbd "C-x k") 'kill-this-buffer)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#000000" "#8b0000" "#00ff00" "#ffa500" "#7b68ee" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(custom-safe-themes (quote ("7abf5a28ec511e7e8f5fe10978b3d63058bbd280ed2b8d513f9dd8b7f5fc9400" "61b188036ad811b11387fc1ef944441826c19ab6dcee5c67c7664a0bbd67a5b5" "d809ca3cef02087b48f3f94279b86feca896f544ae4a82b523fba823206b6040" default)))
 '(fci-rule-color "#383838"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
