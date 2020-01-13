(in-package :gefjon-utils)

(deftype hash-map (&optional key value)
  (declare (ignore key value))
  'hash-table)
