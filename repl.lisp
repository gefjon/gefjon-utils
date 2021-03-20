(uiop:define-package #:gefjon-utils/repl
  (:mix #:cl)
  (:import-from #:quicklisp #:quickload)
  (:export #:load-and-enter #:println #:print-hex))
(in-package #:gefjon-utils/repl)

(defmacro load-and-enter (system-package-designator)
  `(progn
     (quickload ,system-package-designator)
     (in-package ,system-package-designator)))

(defun println (format-string &rest stuff)
  (fresh-line)
  (apply #'format t format-string stuff)
  (terpri))

(defun print-hex (number)
  (println "~x" number))
