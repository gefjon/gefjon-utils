(uiop:define-package gefjon-utils/places
  (:mix cl)
  (:export mapf))
(in-package gefjon-utils/places)

(defmacro mapf (place function)
  "invoke FUNCTION on PLACE and set PLACE to the result.

PLACE must be a setf-able place, and FUNCTION must be a function from
one argument to one value, both of which have the same type as PLACE.

not an atomic swap; potentially not thread-safe."
  `(setf ,place (funcall ,function ,place)))
