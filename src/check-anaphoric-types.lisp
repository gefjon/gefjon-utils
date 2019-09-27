(in-package :gefjon-utils)

(defmacro check-anaphoric-types (&rest places-and-types)
  "PLACES-AND-TYPES must each be a symbol which names both a place and a type"
  (flet ((check-anaphoric-type (place-and-type)
           `(check-type ,place-and-type ,place-and-type)))
    `(progn
       ,@(mapcar #'check-anaphoric-type
                 places-and-types))))
