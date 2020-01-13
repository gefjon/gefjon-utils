(in-package :gefjon-utils)

(defmacro-clause (for |var| slot-name-of |instance| &optional with-class |class-name|)
  "symbols which name slots of a clos instance"
  (let ((class (or |class-name| (gensym "CLASS")))
        (all-slots (gensym "ALL-SLOTS"))
        (slot-names (gensym "SLOT-NAMES")))
    `(progn
       (with ,class = (class-of ,|instance|))
       (with ,all-slots = (closer-mop:class-slots ,class))
       (with ,slot-names = (mapcar #'closer-mop:slot-definition-name ,all-slots))
       (for ,|var| in ,slot-names))))

(defclass print-all-slots-mixin ()
  :documentation "a mixin with a `PRINT-OBJECT' method that prints all its slots")

(defmethod print-object ((object print-all-slots-mixin) stream)
  "print all the slots of OBJECT in the same format as for a `STRUCTURE-OBJECT'"
  (pprint-logical-block (stream nil)
    (write-string "#<" stream)
    (write-string (symbol-name (class-name (class-of object))) stream)
    (pprint-logical-block (stream nil)
      (iter
        (for slot-name slot-name-of object)
        (unless (first-time-p)
          (pprint-newline :linear stream))
        (write-char #\space stream)
        (format stream ":~a ~s" slot-name (slot-value object slot-name))))
    (write-char #\> stream)))


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
    (for slot-name slot-name-of object with-class class)
    (with copy = (allocate-instance class))
    (when (slot-boundp object slot-name)
      (setf (slot-value copy slot-name)
            (slot-value object slot-name)))
    (finally
     (return (apply #'reinitialize-instance copy initargs)))))
