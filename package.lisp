(defpackage :gefjon-utils
  (:use :cl
        :iterate)
  (:shadow :defstruct
           :defclass)
  (:export :defstruct
           :defclass
           :compiler-state
           :compiler-defun
           :coerce-to-string
           :symbol-concatenate
           :make-keyword))
