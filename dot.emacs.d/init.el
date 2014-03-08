;; disable splash
(setq inhibit-startup-message t)

;; hide toolbar
(tool-bar-mode -1)

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
(require-package 'linum)

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

;; configure font
(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Source Code Pro")
  (set-face-attribute 'default nil :height 140))

;; use soft tabs and 4 space indent
(setq-default
  tab-width 4
  tab-stop-list (number-sequence 4 200 4)
  indent-tabs-mode nil)

;; start server
(server-start)

;; display line numbers
(global-linum-mode 1)

;; highlight current line
(global-hl-line-mode)