;; -*- coding: utf-8 -*-
;; By Stumble at 2014.2.24 23:00 around

;;; Misc
;; Turn off alarms
(setq ring-bell-function 'ignore)
(global-set-key (kbd "M-,") 'company-complete)

;;; Theme setup
(when (or (display-graphic-p)
          (string-match-p "256color"(getenv "TERM")))
  (load-theme 'doom-molokai t))

;;; web-mode settings
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  )
(add-hook 'web-mode-hook 'my-web-mode-hook)

;;; useful functions.
;;; add yank-and-indent function
(defun yank-and-indent ()
  "Yank and then indent the newly formed region according to mode."
  (interactive)
  (yank)
  (call-interactively 'indent-region))

(nvmap :prefix ","
  "pp" 'yank-and-indent
  "fof" 'ff-find-other-file
  "ls" 'highlight-symbol
  "df" 'xref-find-definitions-other-window
  "dx" 'xref-find-definitions
  "pop" 'xref-pop-marker-stack
  )

;;; lsp-mode
(with-eval-after-load 'lsp-mode
  ;; enable log only for debug
  (setq lsp-log-io nil)
  ;; use `evil-matchit' instead
  (setq lsp-enable-folding nil)
  ;; no real time syntax check
  ;; (setq lsp-diagnostic-package :none)
  ;; handle yasnippet by myself
  ;; (setq lsp-enable-snippet nil)
  ;; use `company-ctags' only.
  ;; Please note `company-lsp' is automatically enabled if it's installed
  ;; (setq lsp-enable-completion-at-point nil)
  ;; turn off for better performance
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; use find-fine-in-project instead
  (setq lsp-enable-links nil)
  ;; auto restart lsp
  (setq lsp-restart 'auto-restart)
  ;; don't watch 3rd party javascript libraries
  ;; (push "[/\\\\][^/\\\\]*\\.\\(json\\|html\\|jade\\)$" lsp-file-watch-ignored)
  ;; don't ping LSP lanaguage server too frequently
  ;; (defvar lsp-on-touch-time 0)
  ;; (defun my-lsp-on-change-hack (orig-fun &rest args)
  ;;   ;; do NOT run `lsp-on-change' too frequently
  ;;   (when (> (- (float-time (current-time))
  ;;               lsp-on-touch-time) 120) ;; 2 mins
  ;;     (setq lsp-on-touch-time (float-time (current-time)))
  ;;     (apply orig-fun args)))
  ;; (advice-add 'lsp-on-change :around #'my-lsp-on-change-hack)
  (setq lsp-response-timeout 3)
  (setq lsp-idle-delay 0.500)
  ;; (setq lsp-completion-provider :capf)
  ;; (setq lsp-enable-file-watchers nil) ;; this will disable file watcher!
  )

;;; python
;; pip3 install jedi # tests show that rope_py3k is better
;; pip3 install rope_py3k
;; # flake8 for code checks
;; pip3 install flake8
;; # importmagic for automatic imports
;; pip3 install importmagic
;; # and autopep8 for automatic PEP8 formatting
;; pip3 install autopep8
;; # and yapf for code formatting
;; pip3 install yapf
;; (setq elpy-rpc-python-command "python3")
;;; to use python3 elpy set this and install the following
;; (with-eval-after-load 'elpy
;;   (let ((venv-dir "~/.emacs.d/elpy/rpc-venv"))
;;     (if (file-exists-p venv-dir) (pyvenv-activate venv-dir))))

;;; Ocaml
;;; (require 'tuareg)
;; (setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
;; (add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))
;; (require 'ocp-indent)
;; (require 'merlin)
;; (add-hook 'tuareg-mode-hook 'merlin-mode t)
;; (add-hook 'caml-mode-hook 'merlin-mode t)

;;; C++ (lsp)
;; C++ coding styles
(load-file "~/.emacs.d/site-lisp/cpp-styles/bfn.el")
(defun set-cpp-style-hook ()
  (c-set-style "bfn")
  )
(add-hook 'c++-mode-hook 'set-cpp-style-hook)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;; lsp-mode setup for clangd
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      ;; company-idle-delay 0.0
      ;; company-minimum-prefix-length 3
      ;; lsp-idle-delay 0.1
      )  ;; clangd is fast

;;; Coq
;;; coq's proof general mode
;; (load "~/.emacs.d/site-lisp/PG/generic/proof-site")

;;; P4
;;; Add P4_16 mode
(load "~/.emacs.d/site-lisp/p4_16-mode/p4_16-mode.el")
(require 'p4_16-mode)
(add-to-list 'auto-mode-alist '("\\.p4\\'" . p4_16-mode))

;;; Go (lsp)
(require 'go-mode)
(require 'go-rename)
(require 'go-guru)
(require 'company)
(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook #'lsp)
(add-to-list 'lsp-file-watch-ignored "[/\\\\]vendor$")
(add-to-list 'lsp-file-watch-ignored "[/\\\\]build$")
(nvmap :prefix ",go"
  "f" 'gofmt
  "ia" 'go-import-add
  "ir" 'go-remove-unused-imports
  "ec" 'go-errcheck
  "rn" 'go-rename)
;; (add-hook 'go-mode-hook 'go-eldoc-setup)

;;; Rust
;; prefer to use RLS.
;; rustup component add rls rust-analysis rust-src
;; rustup component add rustfmt-preview
;; cargo install cargo-check
;; cargo install clippy
;; cargo install cargo-edit
(require 'rust-mode)
(require 'flycheck-rust)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'rust-mode-hook #'cargo-minor-mode)
(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
(nvmap :prefix ",cg" ;; cg stands for cargo
  "r" 'cargo-process-run
  "f" 'cargo-process-fmt
  "c" 'cargo-process-check
  "b" 'cargo-process-build
  "t" 'cargo-process-test
  "l" 'cargo-process-clippy
  )

;;; Solidity
(setq solidity-comment-style 'slash)
;; (setq flycheck-solidity-solc-addstd-contracts t)
;; (setq solidity-flycheck-solc-checker-active t)
;; (setq solidity-flycheck-solium-checker-active t)
(require 'solidity-mode)
;; (require 'cl)  ;; for remove-if-not function used in solidity-flycheck
;; (require 'solidity-flycheck)
;; (add-hook 'solidity-mode-hook #'flycheck-mode)
;; (require 'company-solidity)
;; (add-hook 'solidity-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'company-backends)
;;                  (append '((company-solidity company-capf company-dabbrev-code))
;;                          company-backends))))
;; (provide 'init-solidity-mode)
;; (add-hook 'after-init-hook #'global-flycheck-mode)

;;; stumble-custom.el ends here

