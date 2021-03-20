(uiop:define-package #:gefjon-utils/special
  (:mix #:gefjon-utils/type-declaration #:cl)
  (:export #:define-special))
(in-package #:gefjon-utils/special)

(defmacro define-special (name &optional (type 't) (documentation "A globally-unbound special variable defined by `gefjon-utils:define-special'"))
  `(progn
     (typedec ,name ,type)
     (defvar ,name)
     (setf (documentation ',name 'variable)
           ,documentation)))
