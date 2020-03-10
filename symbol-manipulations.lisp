(uiop:define-package :gefjon-utils/symbol-manipulations
    (:mix :cl)
  (:export :coerce-to-string :symbol-concatenate :make-keyword))
(cl:in-package :gefjon-utils/symbol-manipulations)

(defun coerce-to-string (object)
  (typecase object
    (symbol (symbol-name object))
    (string object)
    (t (coerce object 'string))))

(defun symbol-concatenate (&rest symbols-or-strings)
  (intern (apply #'concatenate
                 (cons 'string (mapcar #'coerce-to-string
                                       symbols-or-strings)))))

(defun make-keyword (symbol-or-string)
  (intern (coerce-to-string symbol-or-string)
          (find-package :keyword)))
