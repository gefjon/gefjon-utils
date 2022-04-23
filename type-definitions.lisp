(uiop:define-package :gefjon-utils/type-definitions
  (:use :cl)
  (:export
   #:function-return-type
   #:hash-map #:optional #:values! #:func #:void #:tuple #:list-of #:form #:natnum))
(in-package :gefjon-utils/type-definitions)

(defun form-head-p (form head)
  (and (consp form)
       (eq (first form) head)))

(deftype values! (&rest types)
  "Like `cl:values', but implicit additional values are forbidden."
  (flet ((rest-or-optional-p (thing)
           (member thing '(&optional &rest) :test #'eq)))
    (if (find-if #'rest-or-optional-p types) `(values ,@types)
        `(values ,@types &optional))))

(defun function-return-type (type)
  (cond ((eq type 'void) '(values!))
        ((form-head-p type 'values) `(values! ,@(rest type)))
        ((form-head-p type 'values!) type)
        (:otherwise `(values! ,type))))

(deftype func (inputs return-type)
  `(function ,inputs ,(function-return-type return-type)))

(deftype hash-map (&optional key value)
  (declare (ignore key value))
  'hash-table)

(deftype optional (type)
  `(or null ,type))

(deftype list-of (&optional element-type)
  (declare (ignore element-type))
  'list)

(deftype tuple (&rest elements)
  (reduce
   (lambda (new-element existing-type)
     `(cons ,new-element ,existing-type))
   elements
   :from-end t
   :initial-value 'null))

(deftype form ()
  t)

(deftype natnum ()
  '(and fixnum unsigned-byte))
