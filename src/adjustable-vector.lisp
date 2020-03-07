(in-package :gefjon-utils)

(compiler-defun vector-adjustable-p (vector)
  (and (vectorp vector)
       (adjustable-array-p vector)
       (array-has-fill-pointer-p vector)))

(deftype adjustable-vector (&optional element-type)
  `(and (vector ,element-type) (satisfies adjustable-vector-p)))
