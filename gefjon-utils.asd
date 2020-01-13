(defsystem :gefjon-utils
  :version :0.0.0
  :author :gefjon
  :depends-on (:alexandria
               :iterate
               :trivial-types
               :quicklisp
               :closer-mop)
  :components
  ((:file :package)
   (:module :src
            :depends-on (:package)
            :components ((:file :check-anaphoric-types)
                         (:file :compiler-state)
                         (:file :symbol-manipulations
                                :depends-on (:compiler-state))
                         (:file :defstruct-defclass
                                :depends-on (:compiler-state :symbol-manipulations))
                         (:file :clos
                                :depends-on (:symbol-manipulations))
                         (:file :repl-utils)
                         (:file :places)))))
