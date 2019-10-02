(in-package :gefjon-utils)

(defmacro load-and-enter (system-package-designator)
  `(progn
     (ql:quickload ,system-package-designator)
     (in-package ,system-package-designator)))
