(in-package :gefjon-utils)

(compiler-defun vector-adjustable-p (vector)
  (and (vectorp vector)
       (adjustable-array-p vector)
       (array-has-fill-pointer-p vector)))

(deftype adjustable-vector (&optional element-type)
  `(and (vector ,element-type) (satisfies vector-adjustable-p)))

(defmacro make-adjustable-vector (&key (element-type t) initial-contents)
  (alexandria:with-gensyms (length contents)
    `(let* ((,contents ,initial-contents)
            (,length (length ,contents)))
       (make-array ,length
                   :element-type ',element-type
                   :initial-contents ,contents
                   :fill-pointer ,length
                   :adjustable t))))
