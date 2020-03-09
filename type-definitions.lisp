(uiop:define-package :gefjon-utils/type-definitions
    (:mix :cl)
  (:export :hash-map :optional))
(cl:in-package :gefjon-utils/type-definitions)

(deftype hash-map (&optional key value)
  (declare (ignore key value))
  'hash-table)

(deftype optional (type)
  `(or null ,type))
