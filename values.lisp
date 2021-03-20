(uiop:define-package #:gefjon-utils/values
  (:mix #:cl #:iterate)
  (:import-from #:alexandria
                #:with-gensyms #:make-gensym #:make-gensym-list)
  (:export #:map-values))
(in-package #:gefjon-utils/values)

(defmacro map-values (function values-form &rest other-values-forms)
  "Transform multiple values through FUNCTION.

Like `mapcar', but for `values'."
  (let* ((first-name (make-gensym 'map-values))
         (other-names (make-gensym-list (length other-values-forms))))
    `(let* ((,first-name (multiple-value-list ,values-form))
            ,@(iter (for name in other-names)
                (for form in other-values-forms)
                (collect `(,name (multiple-value-list ,form)))))
       (values-list (mapcar ,function ,first-name ,@other-names)))))

(defmacro do-values ((var values-form) &body body)
  "Evaluate BODY for each of the `values' returned by VALUES-FORM, and return the results ass multiple values."
  `(map-values (lambda (,var) ,@body)
               ,values-form))

(defmacro-driver (for name in-values values-form)
  `(,(if generate 'generate 'for)
    ,name in (multiple-value-list ,values-form)))
