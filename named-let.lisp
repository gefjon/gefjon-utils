(uiop:define-package #:gefjon-utils/named-let
  (:mix #:cl)
  (:export #:nlet))
(in-package #:gefjon-utils/named-let)

(defmacro nlet (recurse bindings &body body)
  (flet ((binding-name (binding)
           (etypecase binding
             (cons (first binding))
             ((and symbol (not keyword) (not boolean)) binding)))
         (binding-initform (binding)
           (etypecase binding
             (cons (second binding))
             ((and symbol (not keyword) (not boolean)) nil))))
    `(labels ((,recurse ,(mapcar #'binding-name bindings)
                ,@body))
       (,recurse ,@(mapcar #'binding-initform bindings)))))
