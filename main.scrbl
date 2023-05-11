#lang scribble/manual

@(require (for-label racket dispatch))

@title[#:tag "dispatch"]{dispatch}

@defmodule[dispatch]

@link["https://docs.julialang.org/en/v1/manual/methods/"]{Julia-style multiple dispatch} in Racket

@defform[#:kind "syntax"
         #:id define/dispatch
         (define/dispatch (name [arg type-pred] ...
                                body ...+))]{
 Defines a dispatch option for @racket[name].
}

@(racketblock

  (define/dispatch (add [l1 list?]
                        [l2 list?])
    (append l1 l2))

  (define/dispatch (add [n1 number?]
                        [n2 number?])
    (+ n1 n2))

  (add 1 2)
  (add '(one two) '(three four)))
