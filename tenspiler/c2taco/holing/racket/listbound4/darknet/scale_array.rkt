#lang rosette
(require "./bounded.rkt")
(require "./utils.rkt")
(require rosette/lib/angelic rosette/lib/match rosette/lib/synthax)
(require rosette/solver/smt/bitwuzla)
(current-solver (bitwuzla #:path "/bitwuzla/build/src/main/bitwuzla" #:options (hash ':seed 0)))


 (define-bounded (vec_scalar_mul a x)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (* a (list-ref-noerr x 0 ) ) (vec_scalar_mul a (list-tail-noerr x 1 ) ) ) ))

(define-grammar (scale_array_inv0_gram a agg.result i n ref.tmp s)
 [rv (choose (&& (&& (>= i 0 ) (<= i n ) ) (equal? agg.result (vec_scalar_mul (v0) (v1) ) ) ))]
[v0 (choose s)]
[v1 (choose (list-take-noerr a i ))]
)

(define-grammar (scale_array_ps_gram a n s scale_array_rv)
 [rv (choose (equal? scale_array_rv (vec_scalar_mul (v0) (v1) ) ))]
[v0 (choose s)]
[v1 (choose (list-take-noerr a n ))]
)

(define (scale_array_inv0 a agg.result i n ref.tmp s) (scale_array_inv0_gram a agg.result i n ref.tmp s #:depth 10))
(define (scale_array_ps a n s scale_array_rv) (scale_array_ps_gram a n s scale_array_rv #:depth 10))

(define-symbolic a_BOUNDEDSET-len integer?)
(define-symbolic a_BOUNDEDSET-0 integer?)
(define-symbolic a_BOUNDEDSET-1 integer?)
(define-symbolic a_BOUNDEDSET-2 integer?)
(define-symbolic a_BOUNDEDSET-3 integer?)
(define a (take (list a_BOUNDEDSET-0 a_BOUNDEDSET-1 a_BOUNDEDSET-2 a_BOUNDEDSET-3) a_BOUNDEDSET-len))
(define-symbolic agg.result_BOUNDEDSET-len integer?)
(define-symbolic agg.result_BOUNDEDSET-0 integer?)
(define-symbolic agg.result_BOUNDEDSET-1 integer?)
(define-symbolic agg.result_BOUNDEDSET-2 integer?)
(define-symbolic agg.result_BOUNDEDSET-3 integer?)
(define agg.result (take (list agg.result_BOUNDEDSET-0 agg.result_BOUNDEDSET-1 agg.result_BOUNDEDSET-2 agg.result_BOUNDEDSET-3) agg.result_BOUNDEDSET-len))
(define-symbolic i integer?)
(define-symbolic n integer?)
(define-symbolic ref.tmp integer?)
(define-symbolic s integer?)
(define-symbolic scale_array_rv_BOUNDEDSET-len integer?)
(define-symbolic scale_array_rv_BOUNDEDSET-0 integer?)
(define-symbolic scale_array_rv_BOUNDEDSET-1 integer?)
(define-symbolic scale_array_rv_BOUNDEDSET-2 integer?)
(define-symbolic scale_array_rv_BOUNDEDSET-3 integer?)
(define scale_array_rv (take (list scale_array_rv_BOUNDEDSET-0 scale_array_rv_BOUNDEDSET-1 scale_array_rv_BOUNDEDSET-2 scale_array_rv_BOUNDEDSET-3) scale_array_rv_BOUNDEDSET-len))
(current-bitwidth 6)
(define (assertions)
 (assert (&& (&& (=> (&& (>= n 1 ) (>= (length a ) n ) ) (scale_array_inv0 a (list-empty ) 0 n 0 s) ) (=> (&& (&& (&& (< i n ) (>= n 1 ) ) (>= (length a ) n ) ) (scale_array_inv0 a agg.result i n ref.tmp s) ) (scale_array_inv0 a (list-append agg.result (* (list-ref-noerr a i ) s ) ) (+ i 1 ) n (* (list-ref-noerr a i ) s ) s) ) ) (=> (or (&& (&& (&& (! (< i n ) ) (>= n 1 ) ) (>= (length a ) n ) ) (scale_array_inv0 a agg.result i n ref.tmp s) ) (&& (&& (&& (&& (! true ) (! (< i n ) ) ) (>= n 1 ) ) (>= (length a ) n ) ) (scale_array_inv0 a agg.result i n ref.tmp s) ) ) (scale_array_ps a n s agg.result) ) )))


    (define sol0
        (synthesize
            #:forall (list a_BOUNDEDSET-len a_BOUNDEDSET-0 a_BOUNDEDSET-1 a_BOUNDEDSET-2 a_BOUNDEDSET-3 agg.result_BOUNDEDSET-len agg.result_BOUNDEDSET-0 agg.result_BOUNDEDSET-1 agg.result_BOUNDEDSET-2 agg.result_BOUNDEDSET-3 i n ref.tmp s scale_array_rv_BOUNDEDSET-len scale_array_rv_BOUNDEDSET-0 scale_array_rv_BOUNDEDSET-1 scale_array_rv_BOUNDEDSET-2 scale_array_rv_BOUNDEDSET-3)
            #:guarantee (assertions)
        )
    )
    (sat? sol0)
    (print-forms sol0)
