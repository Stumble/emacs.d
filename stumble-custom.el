;; -*- coding: utf-8 -*-
;; By Stumble at 2014.2.24 23:00 around

(when (or (display-graphic-p)
          (string-match-p "256color"(getenv "TERM")))
  (load-theme 'molokai t))

;;; solution to save the file when the intemediate directory not exit
;;; it will ask you create it or not
;;; use C-x C-f C-f to get out of ido mode to create a new file
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))

;; 屏蔽idle-require的minibuffer中的显示
(setq idle-require-message-verbose nil)

;;; add yank-and-indent function
(defun yank-and-indent ()
  "Yank and then indent the newly formed region according to mode."
  (interactive)
  (yank)
  (call-interactively 'indent-region))

;;; *.vue file for Vue.js
(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))

(nvmap :prefix ","
       "pp" 'yank-and-indent
       "fof" 'ff-find-other-file)

(add-to-list 'auto-mode-alist '("\\.php$" . web-mode))

(setq elpy-rpc-python-command "python3")
;;; to use python3 elpy set this and install the following

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

;;; ocaml setup code begin
;;; (require 'tuareg)
;;; ocaml setup code end

;; (setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
;; (add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))

;; (require 'ocp-indent)
;; (require 'merlin)
;; (add-hook 'tuareg-mode-hook 'merlin-mode t)
;; (add-hook 'caml-mode-hook 'merlin-mode t)

;; set c++ stype to ndn
;; C++ coding styles
;; (load-file "~/.emacs.d/site-lisp/ndn-cpp-style/ndnstyle.el")
;; (load-file "~/.emacs.d/site-lisp/bfn-cpp-style/bfn-cpp-style.el")
;; (load-file "~/.emacs.d/site-lisp/avtools-cpp-style/avtools-cpp-style.el")
;; following does not work.
;; (setq c-default-style "avtools")
;; (add-hook 'c++-mode-hook (lambda ()
;;                           (setq c-set-style "avtools")
;;                           ))

;;; Turn off alarms
(setq ring-bell-function 'ignore)

;;; coq's proof general mode
;; (load "~/.emacs.d/site-lisp/PG/generic/proof-site")

;;; personally, I just don write C.... so..
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(global-set-key (kbd "M-,") 'company-complete)

;;; Add P4_16 mode
(load "~/.emacs.d/site-lisp/p4_16-mode/p4_16-mode.el")
(require 'p4_16-mode)
(add-to-list 'auto-mode-alist '("\\.p4\\'" . p4_16-mode))

;;; use flycheck by default
;;; (add-hook 'after-init-hook #'global-flycheck-mode)

(require 'go-mode)
(require 'go-rename)
;; much more accurate than godef
(require 'go-guru)
(require 'company)
(require 'lsp-mode)
;; annoying to me.
;; (require 'lsp-ui)
(require 'company-lsp)
;; (push 'company-lsp company-backends)
;; (add-hook 'go-mode-hook (lambda ()
;;                           (set (make-local-variable 'company-backends) '(company-lsp))
;;                           (company-mode)))

(add-hook 'go-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)

(add-to-list 'lsp-file-watch-ignored "[/\\\\]vendor$")
(with-eval-after-load 'lsp-mode
  ;; enable log only for debug
  (setq lsp-log-io nil)
  ;; use `evil-matchit' instead
  (setq lsp-enable-folding nil)
  ;; no real time syntax check
  (setq lsp-diagnostic-package :none)
  ;; handle yasnippet by myself
  (setq lsp-enable-snippet nil)
  ;; use `company-ctags' only.
  ;; Please note `company-lsp' is automatically enabled if it's installed
  ;; (setq lsp-enable-completion-at-point nil)
  ;; turn off for better performance
  (setq lsp-enable-symbol-highlighting nil)
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
  )

(nvmap :prefix ",go"
       "j" 'godef-jump-other-window
       "s" 'godef-jump
       "d" 'godef-describe
       "f" 'gofmt
       "ia" 'go-import-add
       "ir" 'go-remove-unused-imports
       "ec" 'go-errcheck
       "rn" 'go-rename)

(add-hook 'go-mode-hook 'go-eldoc-setup)

;; web mode indent = 2
;; You can also set values for web-mode-css-indent-offset for CSS,
;; and web-mode-code-indent-offset Javascript, Java, PHP, etc.
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; rust setup mode
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

;;; stumble-custom.el ends here
