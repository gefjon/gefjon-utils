(in-package :gefjon-utils)

(defun values-form-p (form)
  (and (consp form)
       (eq (first form) 'values)
       form))

(deftype -> (inputs return-type)
  (let ((values-type (or (values-form-p return-type)
                         `(values ,return-type &optional))))
    `(function ,inputs ,values-type)))

(defun function-form-p (form)
  (and (consp form)
       (eq (first form) 'function)
       form))

(defmacro |:| (place type)
  (let ((declare-type (cond ((symbolp place) 'type)
                            ((function-form-p place) 'ftype)
                            (:otherwise (error "don't know how to process type for place ~a" place))))
        (place-name (etypecase place
                      (symbol place)
                      (cons (second place)))))
    `(declaim (,declare-type ,type ,place-name))))
