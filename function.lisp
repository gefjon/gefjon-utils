(uiop:define-package gefjon-utils/function
  (:mix gefjon-utils/type-declaration gefjon-utils/type-definitions cl)
  (:export ~>))
(in-package gefjon-utils/function)

(declaim (inline ~>))

(typedec #'~> (func (function &rest (func (t) t)) (func (&rest t) t)))
(defun ~> (first-function &rest other-functions)
  "Left-to-right function compoistion.

Returns a function which invokes FIRST-FUNCTION, then passes its result to the first of the OTHER-FUNCTIONS,
then passes the new result to the second, and so on."
  (reduce (lambda (accumulator new-function)
            (declare (type function accumulator new-function))
            (lambda (&rest args)
              (multiple-value-call new-function (apply accumulator args))))
          other-functions
          :initial-value first-function))

(define-compiler-macro ~> (first-function &rest other-functions)
  `(lambda (&rest args)
     ,(reduce (lambda (accumulator new-function)
                `(multiple-value-call ,new-function ,accumulator))
              other-functions
              :initial-value `(apply ,first-function args))))
