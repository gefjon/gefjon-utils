(uiop:define-package gefjon-utils/function
  (:mix gefjon-utils/type-declaration gefjon-utils/type-definitions cl)
  (:export ~>))
(in-package gefjon-utils/function)

(declaim (inline ~>))

(typedec #'~> (func (function &rest (func (t) t)) (func (&rest t) t)))
(defun ~> (first-function &rest other-functions)
  (reduce (lambda (accumulator new-function)
            (declare (type (func (&rest t) t) accumulator)
                     (type (func (t) t) new-function))
            (lambda (&rest args)
              (funcall new-function (apply accumulator args))))
          other-functions
          :initial-value first-function))

(define-compiler-macro ~> (first-function &rest other-functions)
  `(lambda (&rest args)
     ,(reduce (lambda (accumulator new-function)
                `(funcall ,new-function ,accumulator))
              other-functions
              :initial-value `(apply ,first-function args))))
