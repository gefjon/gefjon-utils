(uiop:define-package gefjon-utils/type-definitions
  (:mix cl)
  (:export hash-map optional func void))
(in-package gefjon-utils/type-definitions)

(defun values-form-p (form)
  (and (consp form)
       (eq (first form) 'values)
       form))

(defun void-p (form)
  (when (eq form 'void)
    '(values &optional)))

(deftype func (inputs return-type)
  (let ((values-type (or (values-form-p return-type)
                         (void-p return-type)
                         `(values ,return-type &optional))))
    `(function ,inputs ,values-type)))

(deftype hash-map (&optional key value)
  (declare (ignore key value))
  'hash-table)

(deftype optional (type)
  `(or null ,type))
