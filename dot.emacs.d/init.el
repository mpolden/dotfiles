;; disable splash
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)

;; hide toolbar
(tool-bar-mode -1)

;; hide scrollbar
(scroll-bar-mode -1)

;; configure melpa repo
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; install packages
(defun require-package (package &optional min-version no-refresh)
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))
(require-package 'evil)
(require-package 'key-chord)
(require-package 'solarized-theme)
(require-package 'go-mode)
(require-package 'yaml-mode)

;; load evil mode
(require 'evil)
(evil-mode 1)

;; load key-chord
(require 'key-chord)
(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)

;; load ido
(require 'ido)
(ido-mode t)

;; load go-mode
(require 'go-mode-load)

;; set theme
(load-theme 'solarized-dark t)

;; mac
(when (eq system-type 'darwin)
  ;; set font
  (set-face-attribute 'default nil :family "Source Code Pro")
  (set-face-attribute 'default nil :height 140)

  ;; configure modifiers
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta)
  (setq ns-function-modifier 'hyper)

  ;; Norwegian mac-keyboard
  (define-key key-translation-map (kbd "s-8") (kbd "["))
  (define-key key-translation-map (kbd "s-(") (kbd "{"))
  (define-key key-translation-map (kbd "s-9") (kbd "]"))
  (define-key key-translation-map (kbd "s-)") (kbd "}"))
  (define-key key-translation-map (kbd "s-7") (kbd "|"))
  (define-key key-translation-map (kbd "s-/") (kbd "\\"))
  (define-key key-translation-map (kbd "M-s-7") (kbd "M-|")))

;; use soft tabs and 4 space indent
(setq-default
  tab-width 4
  tab-stop-list (number-sequence 4 200 4)
  indent-tabs-mode nil)

;; start server
(server-start)

;; display line numbers
(global-linum-mode 1)
(setq linum-format " %d ")

;; highlight current line
(global-hl-line-mode)

;; bind return to newline-and-indent
(global-set-key (kbd "RET") 'newline-and-indent)

;; make prompts accept y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; no confirmation for non-existent files or buffers
(setq confirm-nonexistent-file-or-buffer nil)

;; highlight matching parentheses
(show-paren-mode 1)

;; highlight lines exceeding 80 columns
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; disable word wrapping
(setq-default truncate-lines 1)
