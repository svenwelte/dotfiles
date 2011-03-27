(add-to-list 'load-path "~/.emacs.d")

(load "rmm5t")

;; Enable a backtrace when problems occur
;; (setq debug-on-error t)

;; some local keybindings
(global-set-key (kbd "s-b") 'ido-switch-buffer)
(global-set-key (kbd "s-x") 'execute-extended-command)
(global-set-key (kbd "M-b") 'ido-switch-buffer)
(global-set-key (kbd "s-o") 'ido-find-file)

;; viper mode
(define-key viper-vi-basic-map "\C-u" 'viper-scroll-screen-back)

(eval-after-load "slime"
  '(progn
     ;; "Extra" features (contrib)
     (slime-setup
      '(slime-repl slime-banner slime-highlight-edits slime-fuzzy))
     (setq
      ;; Use UTF-8 coding
      slime-net-coding-system 'utf-8-unix
      ;; Use fuzzy completion (M-Tab)
      slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
     ;; Use parentheses editting mode paredit
     (defun paredit-mode-enable () (paredit-mode 1))
     (add-hook 'slime-mode-hook 'paredit-mode-enable)
     (add-hook 'slime-repl-mode-hook 'paredit-mode-enable)))

(put 'scroll-left 'disabled nil)
