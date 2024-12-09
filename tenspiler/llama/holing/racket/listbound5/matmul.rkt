#lang rosette
(require "./bounded.rkt")
(require "./utils.rkt")
(require rosette/lib/angelic rosette/lib/match rosette/lib/synthax)
(require rosette/solver/smt/bitwuzla)
(current-solver (bitwuzla #:path "/bitwuzla/build/src/main/bitwuzla" #:options (hash ':seed 0)))



 (define-bounded (matrix_vec_mul matrix_x x)
(if (or (or (< (matrix-length matrix_x ) 1 ) (< (length (matrix-ref-noerr matrix_x 0 ) ) 1 ) ) (! (equal? (length (matrix-ref-noerr matrix_x 0 ) ) (length x ) ) ) ) (list-empty ) (list-prepend (reduce_sum (vec_elemwise_mul (matrix-ref-noerr matrix_x 0 ) x)) (matrix_vec_mul (matrix-tail-noerr matrix_x 1 ) x ) ) ))


 (define-bounded (vec_elemwise_mul x y)
(if (or (< (length x ) 1 ) (! (equal? (length x ) (length y ) ) ) ) (list-empty ) (list-prepend (* (list-ref-noerr x 0 ) (list-ref-noerr y 0 ) ) (vec_elemwise_mul (list-tail-noerr x 1 ) (list-tail-noerr y 1 )) ) ))


 (define-bounded (vec_scalar_mul a x)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (* a (list-ref-noerr x 0 ) ) (vec_scalar_mul a (list-tail-noerr x 1 )) ) ))


 (define-bounded (reduce_sum x)
(if (< (length x ) 1 ) 0 (+ (list-ref-noerr x 0 ) (reduce_sum (list-tail-noerr x 1 )) ) ))

(define-grammar (matmul_inv0_gram agg.result col curr input row weight)
 [rv (choose (&& (&& (>= row 0 ) (<= row (matrix-length weight ) ) ) (equal? agg.result (matrix_vec_mul (v0) (if (VECTOR_OUTER_LOOP_INDEX) (list-take-noerr input row ) input ) ) ) ))]
[v0 (choose (if (MATRIX_OUTER_LOOP_INDEX_FIRST) (matrix-take-noerr weight row ) (matrix-col-slice-noerr (matrix-row-slice-noerr weight 0 (length input ) ) 0 row ) ) (matrix-transpose-noerr (if (MATRIX_OUTER_LOOP_INDEX_FIRST) (matrix-take-noerr weight row ) (matrix-col-slice-noerr (matrix-row-slice-noerr weight 0 (length input ) ) 0 row ) ) ))]
)

(define-grammar (matmul_inv1_gram col curr input weight agg.result row)
 [rv (choose (&& (&& (&& (&& (&& (>= row 0 ) (< row (matrix-length weight ) ) ) (>= col 0 ) ) (<= col (length input ) ) ) (equal? curr (reduce_sum (if (VECTOR_OUTER_LOOP_INDEX) (vec_scalar_mul (list-ref-noerr input row ) (if (MATRIX_OUTER_LOOP_INDEX_FIRST) (list-take-noerr (matrix-ref-noerr weight row ) col ) (matrix-ref-noerr (matrix-transpose-noerr (matrix-col-slice-with-length-noerr (matrix-take-noerr weight col ) row 1 ) ) 0 ) )) (vec_elemwise_mul (if (MATRIX_OUTER_LOOP_INDEX_FIRST) (list-take-noerr (matrix-ref-noerr weight row ) col ) (matrix-ref-noerr (matrix-transpose-noerr (matrix-col-slice-with-length-noerr (matrix-take-noerr weight col ) row 1 ) ) 0 ) ) (list-take-noerr input col )) )) ) ) (equal? agg.result (matrix_vec_mul (v0) (if (VECTOR_OUTER_LOOP_INDEX) (list-take-noerr input row ) input ) ) ) ))]
[v0 (choose (if (MATRIX_OUTER_LOOP_INDEX_FIRST) (matrix-take-noerr weight row ) (matrix-col-slice-noerr (matrix-row-slice-noerr weight 0 (length input ) ) 0 row ) ) (matrix-transpose-noerr (if (MATRIX_OUTER_LOOP_INDEX_FIRST) (matrix-take-noerr weight row ) (matrix-col-slice-noerr (matrix-row-slice-noerr weight 0 (length input ) ) 0 row ) ) ))]
)

(define-grammar (matmul_ps_gram weight input matmul_rv)
 [rv (choose (equal? matmul_rv (matrix_vec_mul (v0) (if (VECTOR_OUTER_LOOP_INDEX) (list-take-noerr input (matrix-length weight ) ) input ) ) ))]
[v0 (choose (if (MATRIX_OUTER_LOOP_INDEX_FIRST) weight (matrix-col-slice-noerr (matrix-row-slice-noerr weight 0 (length input ) ) 0 (matrix-length weight ) ) ) (matrix-transpose-noerr (if (MATRIX_OUTER_LOOP_INDEX_FIRST) weight (matrix-col-slice-noerr (matrix-row-slice-noerr weight 0 (length input ) ) 0 (matrix-length weight ) ) ) ))]
)

(define-grammar (MATRIX_OUTER_LOOP_INDEX_FIRST_gram )
 [rv (choose (v0))]
[v0 (choose true false)]
)

(define-grammar (VECTOR_OUTER_LOOP_INDEX_gram )
 [rv (choose (v0))]
[v0 (choose true false)]
)

(define (matmul_inv0 agg.result col curr input row weight) (matmul_inv0_gram agg.result col curr input row weight #:depth 10))
(define (matmul_inv1 col curr input weight agg.result row) (matmul_inv1_gram col curr input weight agg.result row #:depth 10))
(define (matmul_ps weight input matmul_rv) (matmul_ps_gram weight input matmul_rv #:depth 10))

(define (MATRIX_OUTER_LOOP_INDEX_FIRST ) (MATRIX_OUTER_LOOP_INDEX_FIRST_gram  #:depth 10))
(define (VECTOR_OUTER_LOOP_INDEX ) (VECTOR_OUTER_LOOP_INDEX_gram  #:depth 10))

(define-symbolic agg.result_BOUNDEDSET-len integer?)
(define-symbolic agg.result_BOUNDEDSET-0 integer?)
(define-symbolic agg.result_BOUNDEDSET-1 integer?)
(define-symbolic agg.result_BOUNDEDSET-2 integer?)
(define-symbolic agg.result_BOUNDEDSET-3 integer?)
(define-symbolic agg.result_BOUNDEDSET-4 integer?)
(define agg.result (take (list agg.result_BOUNDEDSET-0 agg.result_BOUNDEDSET-1 agg.result_BOUNDEDSET-2 agg.result_BOUNDEDSET-3 agg.result_BOUNDEDSET-4) agg.result_BOUNDEDSET-len))
(define-symbolic col integer?)
(define-symbolic curr integer?)
(define-symbolic input_BOUNDEDSET-len integer?)
(define-symbolic input_BOUNDEDSET-0 integer?)
(define-symbolic input_BOUNDEDSET-1 integer?)
(define-symbolic input_BOUNDEDSET-2 integer?)
(define-symbolic input_BOUNDEDSET-3 integer?)
(define-symbolic input_BOUNDEDSET-4 integer?)
(define input (take (list input_BOUNDEDSET-0 input_BOUNDEDSET-1 input_BOUNDEDSET-2 input_BOUNDEDSET-3 input_BOUNDEDSET-4) input_BOUNDEDSET-len))
(define-symbolic matmul_rv_BOUNDEDSET-len integer?)
(define-symbolic matmul_rv_BOUNDEDSET-0 integer?)
(define-symbolic matmul_rv_BOUNDEDSET-1 integer?)
(define-symbolic matmul_rv_BOUNDEDSET-2 integer?)
(define-symbolic matmul_rv_BOUNDEDSET-3 integer?)
(define-symbolic matmul_rv_BOUNDEDSET-4 integer?)
(define matmul_rv (take (list matmul_rv_BOUNDEDSET-0 matmul_rv_BOUNDEDSET-1 matmul_rv_BOUNDEDSET-2 matmul_rv_BOUNDEDSET-3 matmul_rv_BOUNDEDSET-4) matmul_rv_BOUNDEDSET-len))
(define-symbolic row integer?)
(define-symbolic weight_BOUNDEDSET-len integer?)
(define-symbolic weight_BOUNDEDSET-0 integer?)
(define-symbolic weight_BOUNDEDSET-1 integer?)
(define-symbolic weight_BOUNDEDSET-2 integer?)
(define-symbolic weight_BOUNDEDSET-3 integer?)
(define-symbolic weight_BOUNDEDSET-4 integer?)
(define-symbolic weight_BOUNDEDSET-5 integer?)
(define-symbolic weight_BOUNDEDSET-6 integer?)
(define-symbolic weight_BOUNDEDSET-7 integer?)
(define-symbolic weight_BOUNDEDSET-8 integer?)
(define-symbolic weight_BOUNDEDSET-9 integer?)
(define-symbolic weight_BOUNDEDSET-10 integer?)
(define-symbolic weight_BOUNDEDSET-11 integer?)
(define-symbolic weight_BOUNDEDSET-12 integer?)
(define-symbolic weight_BOUNDEDSET-13 integer?)
(define-symbolic weight_BOUNDEDSET-14 integer?)
(define-symbolic weight_BOUNDEDSET-15 integer?)
(define-symbolic weight_BOUNDEDSET-16 integer?)
(define-symbolic weight_BOUNDEDSET-17 integer?)
(define-symbolic weight_BOUNDEDSET-18 integer?)
(define-symbolic weight_BOUNDEDSET-19 integer?)
(define-symbolic weight_BOUNDEDSET-20 integer?)
(define-symbolic weight_BOUNDEDSET-21 integer?)
(define-symbolic weight_BOUNDEDSET-22 integer?)
(define-symbolic weight_BOUNDEDSET-23 integer?)
(define-symbolic weight_BOUNDEDSET-24 integer?)
(define weight (take (list (list weight_BOUNDEDSET-0 weight_BOUNDEDSET-1 weight_BOUNDEDSET-2 weight_BOUNDEDSET-3 weight_BOUNDEDSET-4) (list weight_BOUNDEDSET-5 weight_BOUNDEDSET-6 weight_BOUNDEDSET-7 weight_BOUNDEDSET-8 weight_BOUNDEDSET-9) (list weight_BOUNDEDSET-10 weight_BOUNDEDSET-11 weight_BOUNDEDSET-12 weight_BOUNDEDSET-13 weight_BOUNDEDSET-14) (list weight_BOUNDEDSET-15 weight_BOUNDEDSET-16 weight_BOUNDEDSET-17 weight_BOUNDEDSET-18 weight_BOUNDEDSET-19) (list weight_BOUNDEDSET-20 weight_BOUNDEDSET-21 weight_BOUNDEDSET-22 weight_BOUNDEDSET-23 weight_BOUNDEDSET-24)) weight_BOUNDEDSET-len))
(current-bitwidth 6)
(define (assertions)
 (assert (&& (&& (&& (&& (=> (&& (&& (> (matrix-length weight ) 0 ) (> (length (matrix-ref-noerr weight 0 ) ) 0 ) ) (equal? (length (matrix-ref-noerr weight 0 ) ) (length input ) ) ) (matmul_inv0 (list-empty ) 0 0 input 0 weight) ) (=> (&& (&& (&& (&& (< row (matrix-length weight ) ) (> (matrix-length weight ) 0 ) ) (> (length (matrix-ref-noerr weight 0 ) ) 0 ) ) (equal? (length (matrix-ref-noerr weight 0 ) ) (length input ) ) ) (matmul_inv0 agg.result col curr input row weight) ) (matmul_inv1 0 0 input weight agg.result row) ) ) (=> (&& (&& (&& (&& (&& (&& (< col (length input ) ) (< row (matrix-length weight ) ) ) (> (matrix-length weight ) 0 ) ) (> (length (matrix-ref-noerr weight 0 ) ) 0 ) ) (equal? (length (matrix-ref-noerr weight 0 ) ) (length input ) ) ) (matmul_inv0 agg.result col curr input row weight) ) (matmul_inv1 col curr input weight agg.result row) ) (matmul_inv1 (+ col 1 ) (+ curr (* (list-ref-noerr (matrix-ref-noerr weight row ) col ) (list-ref-noerr input col ) ) ) input weight agg.result row) ) ) (=> (&& (&& (&& (&& (&& (&& (! (< col (length input ) ) ) (< row (matrix-length weight ) ) ) (> (matrix-length weight ) 0 ) ) (> (length (matrix-ref-noerr weight 0 ) ) 0 ) ) (equal? (length (matrix-ref-noerr weight 0 ) ) (length input ) ) ) (matmul_inv0 agg.result col curr input row weight) ) (matmul_inv1 col curr input weight agg.result row) ) (matmul_inv0 (list-append agg.result curr ) col curr input (+ row 1 ) weight) ) ) (=> (or (&& (&& (&& (&& (! (< row (matrix-length weight ) ) ) (> (matrix-length weight ) 0 ) ) (> (length (matrix-ref-noerr weight 0 ) ) 0 ) ) (equal? (length (matrix-ref-noerr weight 0 ) ) (length input ) ) ) (matmul_inv0 agg.result col curr input row weight) ) (&& (&& (&& (&& (&& (! true ) (! (< row (matrix-length weight ) ) ) ) (> (matrix-length weight ) 0 ) ) (> (length (matrix-ref-noerr weight 0 ) ) 0 ) ) (equal? (length (matrix-ref-noerr weight 0 ) ) (length input ) ) ) (matmul_inv0 agg.result col curr input row weight) ) ) (matmul_ps weight input agg.result) ) )))


    (define sol0
        (synthesize
            #:forall (list agg.result_BOUNDEDSET-len agg.result_BOUNDEDSET-0 agg.result_BOUNDEDSET-1 agg.result_BOUNDEDSET-2 agg.result_BOUNDEDSET-3 agg.result_BOUNDEDSET-4 col curr input_BOUNDEDSET-len input_BOUNDEDSET-0 input_BOUNDEDSET-1 input_BOUNDEDSET-2 input_BOUNDEDSET-3 input_BOUNDEDSET-4 matmul_rv_BOUNDEDSET-len matmul_rv_BOUNDEDSET-0 matmul_rv_BOUNDEDSET-1 matmul_rv_BOUNDEDSET-2 matmul_rv_BOUNDEDSET-3 matmul_rv_BOUNDEDSET-4 row weight_BOUNDEDSET-len weight_BOUNDEDSET-0 weight_BOUNDEDSET-1 weight_BOUNDEDSET-2 weight_BOUNDEDSET-3 weight_BOUNDEDSET-4 weight_BOUNDEDSET-5 weight_BOUNDEDSET-6 weight_BOUNDEDSET-7 weight_BOUNDEDSET-8 weight_BOUNDEDSET-9 weight_BOUNDEDSET-10 weight_BOUNDEDSET-11 weight_BOUNDEDSET-12 weight_BOUNDEDSET-13 weight_BOUNDEDSET-14 weight_BOUNDEDSET-15 weight_BOUNDEDSET-16 weight_BOUNDEDSET-17 weight_BOUNDEDSET-18 weight_BOUNDEDSET-19 weight_BOUNDEDSET-20 weight_BOUNDEDSET-21 weight_BOUNDEDSET-22 weight_BOUNDEDSET-23 weight_BOUNDEDSET-24)
            #:guarantee (assertions)
        )
    )
    (sat? sol0)
    (print-forms sol0)
