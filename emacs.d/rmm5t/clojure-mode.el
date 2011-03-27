(require 'clojure-test-mode)

(defun clojure-started ()
  (paredit-mode 1)
  (clojure-test-mode)
  (viper-mode))

(add-hook 'clojure-mode-hook 'clojure-started)


(defun clj-run-tests ()
  (interactive)
  (save-buffer)
  (clojure-test-run-tests))
