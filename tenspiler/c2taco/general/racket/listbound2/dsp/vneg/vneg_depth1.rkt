#lang rosette
(require "./bounded.rkt")
(require "./utils.rkt")
(require rosette/lib/angelic rosette/lib/match rosette/lib/synthax)
(require rosette/solver/smt/bitwuzla)
(current-solver (bitwuzla #:path "/Users/sahilbhatia/Documents/bitwuzla/build/src/main/bitwuzla" #:options (hash ':seed 0)))


 (define-bounded (vec_elemwise_add x y)
(if (or (< (length x ) 1 ) (! (equal? (length x ) (length y ) ) ) ) (list-empty ) (list-prepend (+ (list-ref-noerr x 0 ) (list-ref-noerr y 0 ) ) (vec_elemwise_add (list-tail-noerr x 1 ) (list-tail-noerr y 1 ) ) ) ))


 (define-bounded (vec_elemwise_sub x y)
(if (or (< (length x ) 1 ) (! (equal? (length x ) (length y ) ) ) ) (list-empty ) (list-prepend (- (list-ref-noerr x 0 ) (list-ref-noerr y 0 ) ) (vec_elemwise_sub (list-tail-noerr x 1 ) (list-tail-noerr y 1 ) ) ) ))


 (define-bounded (vec_elemwise_mul x y)
(if (or (< (length x ) 1 ) (! (equal? (length x ) (length y ) ) ) ) (list-empty ) (list-prepend (* (list-ref-noerr x 0 ) (list-ref-noerr y 0 ) ) (vec_elemwise_mul (list-tail-noerr x 1 ) (list-tail-noerr y 1 ) ) ) ))


 (define-bounded (vec_elemwise_div x y)
(if (or (< (length x ) 1 ) (! (equal? (length x ) (length y ) ) ) ) (list-empty ) (list-prepend (quotient-noerr (list-ref-noerr x 0 ) (list-ref-noerr y 0 ) ) (vec_elemwise_div (list-tail-noerr x 1 ) (list-tail-noerr y 1 ) ) ) ))


 (define-bounded (vec_scalar_add a x)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (+ a (list-ref-noerr x 0 ) ) (vec_scalar_add a (list-tail-noerr x 1 ) ) ) ))


 (define-bounded (vec_scalar_sub a x)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (- (list-ref-noerr x 0 ) a ) (vec_scalar_sub a (list-tail-noerr x 1 ) ) ) ))


 (define-bounded (vec_scalar_mul a x)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (* a (list-ref-noerr x 0 ) ) (vec_scalar_mul a (list-tail-noerr x 1 ) ) ) ))


 (define-bounded (vec_scalar_div a x)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (quotient-noerr (list-ref-noerr x 0 ) a ) (vec_scalar_div a (list-tail-noerr x 1 ) ) ) ))


 (define-bounded (scalar_vec_sub a x)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (- a (list-ref-noerr x 0 ) ) (scalar_vec_sub a (list-tail-noerr x 1 )) ) ))


 (define-bounded (scalar_vec_div a x)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (quotient-noerr a (list-ref-noerr x 0 ) ) (scalar_vec_div a (list-tail-noerr x 1 )) ) ))


 (define-bounded (vec_map x map_int_to_int)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (map_int_to_int (list-ref-noerr x 0 )) (vec_map (list-tail-noerr x 1 ) map_int_to_int ) ) ))


 (define-bounded (reduce_max x)
(if (<= (length x ) 1 ) (list-ref-noerr x 0 ) (if (> (list-ref-noerr x 0 ) (reduce_max (list-tail-noerr x 1 )) ) (list-ref-noerr x 0 ) (reduce_max (list-tail-noerr x 1 )) ) ))


 (define-bounded (reduce_sum x)
(if (< (length x ) 1 ) 0 (+ (list-ref-noerr x 0 ) (reduce_sum (list-tail-noerr x 1 )) ) ))


 (define-bounded (reduce_mul x)
(if (< (length x ) 1 ) 1 (* (list-ref-noerr x 0 ) (reduce_mul (list-tail-noerr x 1 )) ) ))

(define-grammar (vneg_inv0_gram agg.result arr i n ref.tmp)
 [rv (choose (&& (&& (>= i 0 ) (<= i n ) ) (equal? agg.result (v0) ) ))]
[v0 (choose (vec-slice-noerr (v1) (v2) (v2) ) (v5))]
[v1 (choose arr)]
[v2 (choose (v3) (v4))]
[v3 (choose 0 n i)]
[v4 (choose (integer-sqrt-noerr (v3) ) (integer-exp-noerr (v3) ) (+ (v3) (v3) ) (- (v3) (v3) ) (* (v3) (v3) ) (quotient-noerr (v3) (v3) ))]
[v5 (choose (v6) (vec_elemwise_add (vec-slice-noerr (v1) (v2) (v2) ) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_elemwise_sub (vec-slice-noerr (v1) (v2) (v2) ) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_elemwise_mul (vec-slice-noerr (v1) (v2) (v2) ) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_elemwise_div (vec-slice-noerr (v1) (v2) (v2) ) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_scalar_add (v3) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_scalar_sub (v3) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_scalar_mul (v3) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_scalar_div (v3) (vec-slice-noerr (v1) (v2) (v2) ) ) (scalar_vec_sub (v3) (vec-slice-noerr (v1) (v2) (v2) )) (scalar_vec_div (v3) (vec-slice-noerr (v1) (v2) (v2) )))]
[v6 (choose (vec_map (vec-slice-noerr (v1) (v2) (v2) ) map_int_to_int ))]
)

(define-grammar (vneg_ps_gram arr n vneg_rv)
 [rv (choose (equal? vneg_rv (v0) ))]
[v0 (choose (vec-slice-noerr (v1) (v2) (v2) ) (v5))]
[v1 (choose arr)]
[v2 (choose (v3) (v4))]
[v3 (choose 0 n)]
[v4 (choose (integer-sqrt-noerr (v3) ) (integer-exp-noerr (v3) ) (+ (v3) (v3) ) (- (v3) (v3) ) (* (v3) (v3) ) (quotient-noerr (v3) (v3) ))]
[v5 (choose (v6) (vec_elemwise_add (vec-slice-noerr (v1) (v2) (v2) ) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_elemwise_sub (vec-slice-noerr (v1) (v2) (v2) ) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_elemwise_mul (vec-slice-noerr (v1) (v2) (v2) ) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_elemwise_div (vec-slice-noerr (v1) (v2) (v2) ) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_scalar_add (v3) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_scalar_sub (v3) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_scalar_mul (v3) (vec-slice-noerr (v1) (v2) (v2) ) ) (vec_scalar_div (v3) (vec-slice-noerr (v1) (v2) (v2) ) ) (scalar_vec_sub (v3) (vec-slice-noerr (v1) (v2) (v2) )) (scalar_vec_div (v3) (vec-slice-noerr (v1) (v2) (v2) )))]
[v6 (choose (vec_map (vec-slice-noerr (v1) (v2) (v2) ) map_int_to_int ))]
)

(define-grammar (map_int_to_int_gram int_x)
 [rv (choose (v0))]
[v0 (choose (integer-exp-noerr int_x ) (integer-sqrt-noerr int_x ))]
)

(define (vneg_inv0 agg.result arr i n ref.tmp) (vneg_inv0_gram agg.result arr i n ref.tmp #:depth 10))
(define (vneg_ps arr n vneg_rv) (vneg_ps_gram arr n vneg_rv #:depth 10))

(define (map_int_to_int int_x) (map_int_to_int_gram int_x #:depth 10))

(define-symbolic agg.result_BOUNDEDSET-len integer?)
(define-symbolic agg.result_BOUNDEDSET-0 integer?)
(define-symbolic agg.result_BOUNDEDSET-1 integer?)
(define agg.result (take (list agg.result_BOUNDEDSET-0 agg.result_BOUNDEDSET-1) agg.result_BOUNDEDSET-len))
(define-symbolic arr_BOUNDEDSET-len integer?)
(define-symbolic arr_BOUNDEDSET-0 integer?)
(define-symbolic arr_BOUNDEDSET-1 integer?)
(define arr (take (list arr_BOUNDEDSET-0 arr_BOUNDEDSET-1) arr_BOUNDEDSET-len))
(define-symbolic i integer?)
(define-symbolic n integer?)
(define-symbolic ref.tmp integer?)
(define-symbolic vneg_rv_BOUNDEDSET-len integer?)
(define-symbolic vneg_rv_BOUNDEDSET-0 integer?)
(define-symbolic vneg_rv_BOUNDEDSET-1 integer?)
(define vneg_rv (take (list vneg_rv_BOUNDEDSET-0 vneg_rv_BOUNDEDSET-1) vneg_rv_BOUNDEDSET-len))
(current-bitwidth 6)
(define (assertions)
 (assert (&& (&& (=> (&& (>= n 1 ) (>= (length arr ) n ) ) (vneg_inv0 (list-empty ) arr 0 n 0) ) (=> (&& (&& (&& (< i n ) (>= n 1 ) ) (>= (length arr ) n ) ) (vneg_inv0 agg.result arr i n ref.tmp) ) (vneg_inv0 (list-append agg.result (- 0 (list-ref-noerr arr i ) ) ) arr (+ i 1 ) n (- 0 (list-ref-noerr arr i ) )) ) ) (=> (or (&& (&& (&& (! (< i n ) ) (>= n 1 ) ) (>= (length arr ) n ) ) (vneg_inv0 agg.result arr i n ref.tmp) ) (&& (&& (&& (&& (! true ) (! (< i n ) ) ) (>= n 1 ) ) (>= (length arr ) n ) ) (vneg_inv0 agg.result arr i n ref.tmp) ) ) (vneg_ps arr n agg.result) ) )))


    (define sol0
        (synthesize
            #:forall (list agg.result_BOUNDEDSET-len agg.result_BOUNDEDSET-0 agg.result_BOUNDEDSET-1 arr_BOUNDEDSET-len arr_BOUNDEDSET-0 arr_BOUNDEDSET-1 i n ref.tmp vneg_rv_BOUNDEDSET-len vneg_rv_BOUNDEDSET-0 vneg_rv_BOUNDEDSET-1)
            #:guarantee (assertions)
        )
    )
    (sat? sol0)
    (print-forms sol0)