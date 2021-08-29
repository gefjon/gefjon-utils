(uiop:define-package :gefjon-utils/type-manipulations
  (:mix
   :gefjon-utils/type-declaration
   :gefjon-utils/type-definitions
   :gefjon-utils/define-class
   :cl
   :iterate)
  (:import-from :alexandria
                #:make-gensym-list)
  (:export
   #:type-specifier

   #:subtypep-indeterminate #:smaller #:larger

   #:subtypep*
   
   #:type= #:types-disjoint-p #:types-overlap-p

   #:many-typecase #:many-etypecase #:many-ctypecase))
(in-package :gefjon-utils/type-manipulations)

(deftype type-specifier ()
  '(or list symbol))

(define-class subtypep-indeterminate
    ((smaller type-specifier)
     (larger type-specifier))
  :condition t)

(typedec #'subtypep* (func (type-specifier type-specifier) boolean))
(defun subtypep* (smaller larger)
  "Like `cl:subtypep', but signals an error of type `subtypep-indeterminate' if the relationship cannot be determined."
  (multiple-value-bind (subtypep successp) (subtypep smaller larger)
    (if successp subtypep
      (error 'subtypep-indeterminate
             :smaller smaller
             :larger larger))))

(typedec #'type= (func (type-specifier type-specifier) boolean))
(defun type= (lht rht)
  (and (subtypep* lht rht) (subtypep* rht lht)))

(typedec #'types-disjoint-p (func (type-specifier type-specifier) boolean))
(defun types-disjoint-p (lht rht)
  (subtypep* `(and ,lht ,rht) nil))

(typedec #'types-overlap-p (func (type-specifier type-specifier) boolean))
(defun types-overlap-p (lht rht)
  (not (types-disjoint-p lht rht)))

(defun many-typecase-form (values body-clauses otherwise-form)
  (let* ((names (alexandria:make-gensym-list (length values))))
    (labels ((bind-temp-name (name initform)
               (list name initform))
             (typep-form (name type)
               `(typep ,name ',type))
             (cond-clause (clause)
               (destructuring-bind (types &body body) clause
                 `((and ,@(mapcar #'typep-form names types))
                   ,@body))))
      `(let ,(mapcar #'bind-temp-name names values)
         (cond ,@(mapcar #'cond-clause body-clauses)
               (t ,otherwise-form))))))

(defmacro many-typecase ((&rest values) &body clauses)
  (many-typecase-form values clauses nil))

(defmacro many-etypecase ((&rest values) &body clauses)
  (many-typecase-form values clauses '(error "fell through many-etypecase expression")))

(defmacro many-ctypecase ((&rest values) &body clauses)
  (many-typecase-form values clauses '(cerror "fell through many-ctypecase expression")))
