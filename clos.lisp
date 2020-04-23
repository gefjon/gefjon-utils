(uiop:define-package :gefjon-utils/clos
    (:mix
     :gefjon-utils/iterate
     :iterate
     :cl)
  (:export :print-all-slots-mixin :shallow-copy))
(cl:in-package :gefjon-utils/clos)

;; this has to be a `CL:DEFCLASS' form rather than a
;; `GEFJON-UTLS:DEFINE-CLASS' because that macro inserts this as a mixin
;; to all its class definitions; using the raw `DEFCLASS' avoids a
;; circular dependency
(defclass print-all-slots-mixin () ()
  (:documentation "a mixin with a `PRINT-OBJECT' method that prints all its slots"))

(defmethod print-object ((object print-all-slots-mixin) stream)
  "print all the slots of OBJECT in the same format as for a `STRUCTURE-OBJECT'"
  (pprint-logical-block (stream nil)
    (print-unreadable-object (object stream :type nil :identity nil)
      ;; i manually print the name of the class rather than passing
      ;; `:type t' to `PRINT-UNREADABLE-OBJECT' because i don't like
      ;; the extra clutter of the package designator
      (write-string (symbol-name (class-name (class-of object))) stream)
      (pprint-logical-block (stream nil)
        (iter
          (for slot-name slot-name-of object bound-only t)
          (unless (first-time-p)
            (pprint-newline :linear stream))
          (write-char #\space stream)
          (format stream ":~a ~s" slot-name (slot-value object slot-name)))))))


(defgeneric shallow-copy (object &rest initargs &key &allow-other-keys)
  (:documentation "Makes and returns a shallow copy of OBJECT."))

(defmethod shallow-copy ((object standard-object) &rest initargs &key &allow-other-keys)
  "Shallow copy a CLOS instance.

An uninitialized object of the same class as OBJECT is allocated by
calling ALLOCATE-INSTANCE.  For all slots returned by CLASS-SLOTS, the
returned object has the same slot values and slot-unbound status as
OBJECT.

REINITIALIZE-INSTANCE is called to update the copy with INITARGS.

from https://stackoverflow.com/questions/11067899/is-there-a-generic-method-for-cloning-clos-objects"
  (iter
    (with copy = (allocate-instance (class-of object)))
    (for slot-name slot-name-of object bound-only t)
    (setf (slot-value copy slot-name)
          (slot-value object slot-name))
    (finally
     (return (apply #'reinitialize-instance copy initargs)))))
