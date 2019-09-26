(defsystem :gefjon-utils
  :version :0.0.0
  :author :gefjon
  :depends-on (:alexandria
               :iterate
               :trivial-types)
  :components
  ((:file :package)
   (:module :src
            :depends-on (:package)
            :components ((:file :compiler-state)
                         (:file :symbol-manipulations
                                :depends-on (:compiler-state))
                         (:file :defstruct-defclass
                                :depends-on (:compiler-state :symbol-manipulations))))))
