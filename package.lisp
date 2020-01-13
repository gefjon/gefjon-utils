(defpackage :gefjon-utils
  (:use :cl
        :iterate)
  (:shadow :defstruct
           :defclass)
  (:export
   :slot-descriptor
   :slot-descriptor-type
   :slot-descriptor-name
   :slot-descriptors-types
   :slot-descriptors-names
   :constructor-name
   :defstruct
   :defclass
   :define-boa-constructor-for-class
   :print-all-slots-mixin
   :shallow-copy
   :compiler-state
   :compiler-defun
   :coerce-to-string
   :symbol-concatenate
   :make-keyword
   :check-anaphoric-types
   :load-and-enter
   :mapf
   :hash-map))
