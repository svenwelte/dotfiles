;; do not nag over version mismatch
(setq slime-protocol-version 'ignore)

;; fast connect
(defun sl ()
  "connect to localhost:4005"
  (interactive)
  (slime-connect "localhost" 4005))

