#lang racket/base

(provide define/dispatch)

(require
  racket/string
  racket/format
  (for-syntax syntax/parse
              racket/base
              racket/set))

(define dispatch-table (make-hash))

(struct dispatch-method (name types type-names body) #:transparent)

(define-for-syntax dispatch-names (mutable-set))

(define-syntax (define/dispatch stx)
  (syntax-parse stx
    [(_ (name (args types) ...) body:expr ...+)
     (define already-defined
       (set-member? dispatch-names 'name))
     (set-add! dispatch-names 'name)
     #`(begin
         (register-dispatch-method! 'name
                                    (list types ...)
                                    (list 'types ...)
                                    (λ (args ...) body ...))
         #,(if already-defined #'(void)
               #'(define name
                   (make-dispatch-proc 'name)))
         (void))]))

(define (register-dispatch-method! name types type-names body)
  (define new-method (dispatch-method name types type-names body))
  (hash-set! dispatch-table name
             (if (hash-has-key? dispatch-table name)
                 (cons new-method (hash-ref dispatch-table name))
                 (list new-method))))

(define ((make-dispatch-proc name) . args)
  (define options (hash-ref dispatch-table name))
  (or (for/first ([option options]
                  #:when (dispatch-types-match?
                          (dispatch-method-types option)
                          args))
        (apply (dispatch-method-body
                option)
               args))
      (raise-dispatch-error
       name args (map dispatch-method-type-names options))))

(define (dispatch-types-match? types args)
  (for/and ([type? types]
            [arg args])
    (type? arg)))

(define (raise-dispatch-error name given type-options)
  (define options-str
    (string-join (map (λ (type-names)
                        (format "- ~a" (string-join
                                        (map ~a type-names))))
                      type-options)
                 "\n"))
  (error name "~nNo dispatch option for arguments ~a~n~nOptions are:~n~a"
         (map ~s given) options-str))
