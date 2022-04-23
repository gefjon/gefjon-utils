(uiop:define-package :gefjon-utils/generic-subst
  (:use :gefjon-utils/define-class :gefjon-utils/clos :cl)
  (:shadow #:subst)
  (:export #:subst #:subst-all-slots #:subst-atom))
(in-package :gefjon-utils/generic-subst)

(define-class subst-all-slots ()
  :documentation "A mixin which causes the generic `subst' to treat this `standard-class' as a trunk node, recursing on all its bound slots.")

(define-class subst-atom ()
  :documentation "A mixin which causes the generic `subst' to treat this `standard-class' as a leaf node, not recursing into it. Note that this is the default behavior, but this mixin exists for cases when it is necessary to override inherited behavior.")

(defgeneric subst (new old tree &key test)
  (:documentation "A generic version of `CL:SUBST', capable of recursing on trees other than `CONS'.

An `:around' method handles applying TEST to OLD and TREE as well as
providing a default value for TEST; recursion on the subfields of TREE
is the responsibility of normal methods. `standard-class'es should
mix-in `subst-all-slots' to recurse into all slots; for other behavior
or nonstandard metaclasses, define methods on this function.")
  (:method :around (new old tree &key (test #'eql))
    (if (funcall test old tree)
        new
        (call-next-method new old tree :test test))))

(macrolet
    ((recursively (&body body)
       `(flet ((recurse (subtree)
                 (subst new old subtree :test test)))
          ,@body))
     (defsubst (specializer &body body)
       `(defmethod subst (new old (tree ,specializer) &key test)
          ,@body)))
  (defsubst subst-atom
    "The method for `subst-atom', which does not recurse. Return TREE."
    (declare (ignorable new old test))
    tree)
  (defsubst t
    "The default method, which does not recurse. Return TREE."
    (declare (ignorable new old test))
    tree)
  (defsubst subst-all-slots
    "The method for `subst-all-slots', which recurses on all the bound slots of TRUNK.

Return a new instance of the same class as TRUNK, each of whose slots is the result of recursing on that slot-value of TRUNK."
    (recursively (map-slots #'recurse tree)))
  (defsubst cons
    "Recurse on both the `car' and the `cdr' of TRUNK, constructing a new `cons'."
    (recursively (cons (recurse (car tree))
                       (recurse (cdr tree)))))
  (defsubst vector
    "Recurse on all the elements of TRUNK, constructing a `vector'
with element-type (or (array-element-type TRUNK) (type-of NEW))."
    (recursively
     (map `(vector (or ,(array-element-type tree)
                       ,(type-of new)))
          #'recurse tree))))
