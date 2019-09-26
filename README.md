# gefjon-utils

any time i write the same function/macro/whatever more than once in a different
project, i move the shared code into this package. most notably, it shadows
DEFSTRUCT and DEFCLASS with a different syntax, which i prefer. it looks like:

```lisp
(gefjon-utils:defstruct FOO
  ((BAR fixnum)
   (BAZ string)))
```

note that the slot types are not optional. the list of slot descriptors may be
followed by some keyword arguments, which are subject to change and will vary
between the DEFSTRUCT and DEFCLASS versions. as of writing this:

- :DOCUMENTATION, a docstring to associate with the new class/struct.
- :REPR-TYPE, for structs only, either CL:VECTOR or CL:LIST; passed to
  CL:DEFSTRUCT
- :SUPERCLASSES, for classes only, a list of (symbols naming) superclasses

a form like the one above will:

- ensure the definition of a type named FOO
- define a boa constructor (MAKE-FOO BAR BAZ) and DECLAIM its FTYPE
  appropriately
- ensure the definition of accessors (FOO-BAR FOO) and (FOO-BAZ FOO). for
  structs, also DECLAIM the FTYPEs of the accessors appropriately (class
  accessors are generic functions, so this is not meaningful).
- define the struct or class itself, obviously
