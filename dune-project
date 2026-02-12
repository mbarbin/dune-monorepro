(lang dune 3.20)

(name monorepro)

(generate_opam_files)

(implicit_transitive_deps false)

(package
 (name monorepro)
 (depends
  (foo
   (>= 0.0.1))
  (bar
   (>= 0.0.1))))
