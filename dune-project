(lang dune 3.20)

(name monorepro)

(generate_opam_files)

(implicit_transitive_deps false)

(pin
 (url repo/nonempty-list)
 (package
  (name nonempty-list)
  (version v0.17)))

(package
 (name monorepro)
 (depends
  (ocaml
   (>= 5.3.0))
  (bar
   (>= 0.0.1))
  (foo
   (>= 0.0.1))
  (nonempty-list
   (>= v0.17))))
