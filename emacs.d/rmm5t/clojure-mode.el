(defun turn-on-paredit () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'turn-on-paredit)
;; (add-hook 'clojure-mode-hook 'viper-mode)
