(uiop:define-package :gefjon-utils/iterate
    (:mix :iterate :cl)
  (:import-from :closer-mop
   :slot-definition-name :class-slots)
  (:export :skip-nil))
(cl:in-package :gefjon-utils/iterate)

(defmacro skip-nil (var)
  "an ITERATE clause. skip iterations where VAR is NIL."
  `(unless ,var
     (next-iteration)))

(defmacro-driver (for |var| slot-name-of |instance| &optional
                      bound-only |bound-only-p|
                      with-class |class-name|
                      with-slot-definition |slot-definition|)
  "symbols which name slots of a clos instance"
  (let ((class (or |class-name| (gensym "CLASS")))
        (slot-definition (or |slot-definition| (gensym "SLOT-DEFINITION")))
        (bound-only-p (gensym "BOUND-ONLY-P"))
        (instance (gensym "instance"))
        (kwd (if generate 'generate 'for)))
    `(progn
       (with ,instance = ,|instance|)
       (with ,class = (class-of ,instance))
       (with ,bound-only-p = ,|bound-only-p|)
       (generate ,slot-definition in (class-slots ,class))
       (,kwd ,|var| next (do ((name (slot-definition-name (next ,slot-definition))
                                    (slot-definition-name (next ,slot-definition))))
                             ((or (not ,bound-only-p) (slot-boundp ,instance name))
                              name))))))
