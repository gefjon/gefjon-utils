(uiop:define-package :gefjon-utils/type-declaration
  (:use :cl)
  (:import-from :gefjon-utils/type-definitions
                #:func #:void)
  (:export #:typedec #:assert-type #:the! #:attempt-coerce))
(in-package :gefjon-utils/type-declaration)

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

(deftype plausible-coerce-target ()
  '(or sequence character complex float function))

(defun coerce-target-p (target-type)
  (or (eq target-type t)
      (values (subtypep target-type 'plausible-coerce-target))))

(declaim (inline call-with-attempt-coerce-restart))
(defun call-with-attempt-coerce-restart (datum expected-type func)
  (labels ((same-type-error-p (condition)
             (and (typep condition 'type-error)
                  (eq (type-error-expected-type condition) expected-type)
                  (eq (type-error-datum condition) datum)))
           (offer-to-coerce-p (condition)
             (and (coerce-target-p expected-type)
                  (same-type-error-p condition)))
           (attempt-to-coerce ()
             (return-from call-with-attempt-coerce-restart
               (coerce datum expected-type)))
           (report-fn (stream)
             (format stream "Use COERCE to convert ~s to a ~a"
                     datum expected-type)))
        (restart-bind ((attempt-coerce #'attempt-to-coerce
                                       :test-function #'offer-to-coerce-p
                                       :report-function #'report-fn))
          (funcall func))))

(defmacro with-attempt-coerce-restart ((datum expected-type) &body body)
  `(call-with-attempt-coerce-restart ,datum ,expected-type (lambda () ,@body)))

(declaim (inline signal-type-error))
(defun signal-type-error (datum expected-type)
  (with-attempt-coerce-restart (datum expected-type)
    (error 'type-error
           :datum datum
           :expected-type expected-type)))

(declaim (inline assert-type))
(defun assert-type (datum expected-type)
  (if (typep datum expected-type)
      datum
      (signal-type-error datum expected-type)))

(defmacro the! (expected-type expr)
  `(assert-type ,expr ',expected-type))

(defun attempt-coerce ()
  (invoke-restart 'attempt-coerce))
