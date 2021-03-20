(uiop:define-package #:gefjon-utils/type-declaration
  (:mix #:cl)
  (:import-from #:gefjon-utils/type-definitions
                #:func #:void)
  (:export #:typedec))
(in-package #:gefjon-utils/type-declaration)

(defun function-form-p (form)
  (and (consp form)
       (eq (first form) 'function)
       form))

(defmacro typedec (place type)
  (let ((declare-type (cond ((symbolp place) 'type)
                            ((function-form-p place) 'ftype)
                            (:otherwise (error "don't know how to process type for place ~a" place))))
        (place-name (etypecase place
                      (symbol place)
                      (cons (second place)))))
    `(declaim (,declare-type ,type ,place-name))))
