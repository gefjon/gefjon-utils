(uiop:define-package gefjon-utils/symbol-manipulations
  (:mix cl)
  (:export coerce-to-string make-keyword))
(in-package gefjon-utils/symbol-manipulations)

(defun coerce-to-string (object)
  (typecase object
    (symbol (symbol-name object))
    (string object)
    (t (coerce object 'string))))

(defun make-keyword (symbol-or-string)
  (intern (coerce-to-string symbol-or-string)
          (find-package :keyword)))
