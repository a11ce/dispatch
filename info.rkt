#lang info

(define collection "dispatch")

(define scribblings
  '(("main.scrbl"
     '() ; flags
     '(library)
     "dispatch")))

(define deps
  '("base"))

(define build-deps
  '("racket-doc"
    "scribble-lib"))
