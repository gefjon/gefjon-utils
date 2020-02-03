(in-package :gefjon-utils)

(defmacro skip-nil (var)
  "an ITERATE clause. skip iterations where VAR is NIL."
  `(unless ,var
     (next-iteration)))

(defmacro-clause (for |var| slot-name-of |instance| &optional bound-only |bound-only-p| with-class |class-name|)
  "symbols which name slots of a clos instance"
  (let ((class (or |class-name| (gensym "CLASS")))
        (all-slots (gensym "ALL-SLOTS"))
        (slot-names (gensym "SLOT-NAMES"))
        (bound-slot-names (gensym "BOUND-SLOTS"))
        (slot-name (gensym "SLOT-NAME"))
        (instance (gensym "instance")))
    `(progn
       (with ,instance = ,|instance|)
       (with ,class = (class-of ,instance))
       (with ,all-slots = (closer-mop:class-slots ,class))
       (with ,slot-names = (mapcar #'closer-mop:slot-definition-name ,all-slots))
       (with ,bound-slot-names = ,(if |bound-only-p|
                                      `(flet ((slot-unbound-p (,slot-name)
                                                (not (slot-boundp ,instance ,slot-name))))
                                         (remove-if #'slot-unbound-p ,slot-names))
                                      slot-names))
       (for ,|var| in ,bound-slot-names))))
