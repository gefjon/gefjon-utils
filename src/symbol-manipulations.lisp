(in-package :gefjon-utils)

(compiler-defun coerce-to-string (object)
  (typecase object
    (symbol (symbol-name object))
    (string object)
    (t (coerce object 'string))))

(compiler-defun symbol-concatenate (&rest symbols-or-strings)
  (intern (apply #'concatenate
                 (cons 'string (mapcar #'coerce-to-string
                                       symbols-or-strings)))))

(compiler-defun make-keyword (symbol-or-string)
  (intern (coerce-to-string symbol-or-string)
          (find-package :keyword)))
