(uiop:define-package :gefjon-utils/ignorable-destructuring-bind
  (:use :cl :iterate)
  (:shadow #:destructuring-bind)
  (:export #:destructuring-bind #:_))
(cl:in-package :gefjon-utils/ignorable-destructuring-bind)

(eval-when (:compile-toplevel :load-toplevel)
  (defun transform-pattern-ignore-nil-and-underscore (pattern)
    "Returns (values NEW-PATTERN IGNORED-VARS), where IGNORED-VARS is a list of gensyms that should be declared ignore"
    (iter (for pat in pattern)
      (etypecase pat
        ((or null (eql _))
         (let* ((replacement (gensym)))
           (collect replacement into new-pattern)
           (collect replacement into ignored-vars)))
        (symbol (collect pat into new-pattern))
        (list (multiple-value-bind (sub-pat sub-ignores)
                  (transform-pattern-ignore-nil-and-underscore pat)
                (collect sub-pat into ignores)
                (appending sub-ignores into ignores))))
      (finally (return (values new-pattern ignored-vars))))))

(defmacro destructuring-bind (pattern expr &body body)
  "Like `cl:destructuring-bind', but the symbols `_' and `nil' in the PATTERN are treated as ignored.

Does not support improper lists as patterns. Use `&rest' instead of a dotted list."
  (multiple-value-bind (pattern ignores)
      (transform-pattern-ignore-nil-and-underscore pattern)
    `(cl:destructuring-bind ,pattern ,expr
       (declare (ignore ,@ignores))
       ,@body)))
