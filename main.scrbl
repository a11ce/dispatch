#lang scribble/manual

@(require (for-label racket dispatch))

@title[#:tag "dispatch"]{dispatch}

@defmodule[dispatch]

@link["https://docs.julialang.org/en/v1/manual/methods/"]{Julia-style multiple dispatch} in Racket

@section[@code{define/dispatch}]

@defform[#:kind "syntax"
         #:id define/dispatch
         (define/dispatch (name [arg type-pred] ...
                                body ...+))]{
 Defines a dispatch option for the procedure @racket[name].
}

@section{Example}

@(racketblock

  (define/dispatch (add [l1 list?]
                        [l2 list?])
    (append l1 l2))

  (define/dispatch (add [n1 number?]
                        [n2 number?])
    (+ n1 n2))

  (add 1 2)
  (add '(one two) '(three four)))

@section{Safety}

@code{dispatch} is unsafe as defined in @italic[@link["https://lexi-lambda.github.io/blog/2016/02/18/simple-safe-multimethods-in-racket/"]{Simple, safe multimethods in Racket}]. @other-doc['(lib "scribblings/multimethod.scrbl")] is a safe alternative, but works only with structs.
