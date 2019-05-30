(defmacro org-recent-headings-defdebug (name sexp)
  "FIXME"
  (declare (indent defun))
  `(defun ,(intern (concat "org-recent-headings-debug-" (symbol-name name))) ()
     "docstring"
     (interactive)
     (with-current-buffer (get-buffer-create "*org-recent-headings-debug*")
       (erase-buffer)
       (insert "'(")
       (--each org-recent-headings-list
         (-let (((&plist :file file :id id :outline-path olp) (car it)))
           (prin1 ,sexp (current-buffer))
           (insert "\n")))
       (insert ")")
       (emacs-lisp-mode)
       (flycheck-mode -1)
       (goto-char (point-min))
       (indent-pp-sexp t)
       (switch-to-buffer (current-buffer)))))

(org-recent-headings-defdebug scores
  (cons (frecency-score it :get-fn (lambda (item key)
                                     (plist-get (cdr item) key)))
        it))

(org-recent-headings-defdebug main
  (a-list :file file :outline-path olp :id id :cdr (cdr it)))
