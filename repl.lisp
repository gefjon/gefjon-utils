(uiop:define-package gefjon-utils/repl
  (:mix cl)
  (:import-from quicklisp quickload)
  (:export load-and-enter))
(in-package gefjon-utils/repl)

(defmacro load-and-enter (system-package-designator)
  `(progn
     (quickload ,system-package-designator)
     (in-package ,system-package-designator)))
