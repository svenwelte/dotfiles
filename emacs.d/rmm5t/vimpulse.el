(require 'vimpulse)

;; Comment/uncomment Visual selection with ,c
(vimpulse-vmap ",c" 'comment-dwim)
(vimpulse-map ",b" 'ido-switch-buffer)


;; S-expression text objects
(vimpulse-define-text-object vimpulse-sexp (arg)
  "Select a S-expression."
  :keys '("ae" "ie")
  (vimpulse-inner-object-range
   arg
   'backward-sexp
   'forward-sexp))

;; Disable vi keys in the minibuffer
(remove-hook 'minibuffer-setup-hook 'viper-minibuffer-setup-sentinel)
(defadvice viper-set-minibuffer-overlay (around vimpulse activate) nil)
(define-key minibuffer-local-map (kbd "ESC") 'abort-recursive-edit)

(setq-default viper-auto-indent t)