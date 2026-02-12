# Locking issue with cross-project version bounds

## Summary

In this monorepo setup where sub-projects live under `repo/`, `dune pkg lock`
fails with version incompatibility errors on local packages, while `dune build`
succeeds.

## Structure

Here we simulate a setup where repo/nonempty_list would be the place where that
package is developed.

```
dune-project          # root project "monorepro", depends on foo, bar, nonempty-list
dune-workspace        # references mbarbin opam repository (which publishes nonempty-list)
repo/
  nonempty-list/      # local package, also published in custom opam repositories
  bar/                # local package, depends on foo >= 0.0.1, nonempty-list >= v0.17
  foo/                # local package, depends on nonempty-list >= v0.17
src/
  main.ml             # executable using foo, bar, nonempty-list
test/
  run.t               # cram test showing the project builds and runs correctly
```

## Reproducing

The project builds and tests pass:

```sh
$ dune build
$ dune runtest
```

But `dune pkg lock` fails:

```sh
$ dune pkg lock
```

```
Error:
Unable to solve dependencies while generating lock directory: dune.lock

The dependency solver failed to find a solution for the following platforms:
- arch = x86_64; os = linux
- arch = arm64; os = linux
- arch = x86_64; os = macos
- arch = arm64; os = macos
...with this error:
Couldn't solve the package dependency formula.
Selected candidates: bar.dev foo.dev monorepro.dev ocaml.5.3.0
                     ocaml-base-compiler.5.4.0 ocaml-config.3
                     ocaml-options-vanilla.1 bar&foo&monorepro&nonempty-list
                     ocaml-variants ocaml-base-compiler ocaml-base-compiler
- nonempty-list -> (problem)
    bar dev requires >= v0.17
    Rejected candidates:
      nonempty-list.dev: Incompatible with restriction: >= v0.17
- ocaml-compiler -> (problem)
    ocaml-base-compiler 5.4.0 requires = 5.4.0
    Rejected candidates:
      ocaml-compiler.5.6: Incompatible with restriction: = 5.4.0
      ocaml-compiler.5.5: Incompatible with restriction: = 5.4.0
      ocaml-compiler.5.4.0: Requires ocaml = 5.4.0
      ocaml-compiler.5.4.0~rc1: Incompatible with restriction: = 5.4.0
      ocaml-compiler.5.4.0~beta2: Incompatible with restriction: = 5.4.0
      ...
- ocaml-variants -> (problem)
    Rejected candidates:
      ocaml-variants.5.6.0+trunk:
        In same conflict class (ocaml-core-compiler) as ocaml-base-compiler
      ocaml-variants.5.5.0+trunk:
        In same conflict class (ocaml-core-compiler) as ocaml-base-compiler
      ocaml-variants.5.4.1+trunk:
        In same conflict class (ocaml-core-compiler) as ocaml-base-compiler
      ocaml-variants.5.4.0+options:
        In same conflict class (ocaml-core-compiler) as ocaml-base-compiler
      ocaml-variants.5.4.0~rc1+options:
        In same conflict class (ocaml-core-compiler) as ocaml-base-compiler
      ...
```

## Observation

The `nonempty-list` package is both a local package in this repo and a package
published in opam repositories. The error reports that `nonempty-list.dev` is
incompatible with the `>= v0.17` bound.

The `foo` and `bar` packages, which are fictional names not published anywhere,
do not trigger this error despite having similar cross-dependency version
bounds.
