#lang rosette
(require "./bounded.rkt")
(require "./utils.rkt")
(require rosette/lib/angelic rosette/lib/match rosette/lib/synthax)
(require rosette/solver/smt/bitwuzla)
(current-solver (bitwuzla #:path "/Users/sahilbhatia/Documents/bitwuzla/build/src/main/bitwuzla" #:options (hash ':seed 0)))


 (define-bounded (matrix_vec_mul matrix_x x)
(if (or (or (< (matrix-length matrix_x ) 1 ) (< (length (matrix-ref-noerr matrix_x 0 ) ) 1 ) ) (! (equal? (length (matrix-ref-noerr matrix_x 0 ) ) (length x ) ) ) ) (list-empty ) (list-prepend (reduce_sum (vec_elemwise_mul (matrix-ref-noerr matrix_x 0 ) x )) (matrix_vec_mul (matrix-tail-noerr matrix_x 1 ) x ) ) ))


 (define-bounded (reduce_sum x)
(if (< (length x ) 1 ) 0 (+ (list-ref-noerr x 0 ) (reduce_sum (list-tail-noerr x 1 )) ) ))


 (define-bounded (vec_map x map_int_to_int)
(if (< (length x ) 1 ) (list-empty ) (list-prepend (map_int_to_int (list-ref-noerr x 0 )) (vec_map (list-tail-noerr x 1 ) map_int_to_int ) ) ))


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


 (define-bounded (matrix_scalar_add a matrix_x)
(if (< (matrix-length matrix_x ) 1 ) (matrix-empty ) (matrix-prepend (vec_scalar_add a (matrix-ref-noerr matrix_x 0 ) ) (matrix_scalar_add a (matrix-tail-noerr matrix_x 1 ) ) ) ))


 (define-bounded (matrix_scalar_sub a matrix_x)
(if (< (matrix-length matrix_x ) 1 ) (matrix-empty ) (matrix-prepend (vec_scalar_sub a (matrix-ref-noerr matrix_x 0 ) ) (matrix_scalar_sub a (matrix-tail-noerr matrix_x 1 ) ) ) ))


 (define-bounded (matrix_scalar_mul a matrix_x)
(if (< (matrix-length matrix_x ) 1 ) (matrix-empty ) (matrix-prepend (vec_scalar_mul a (matrix-ref-noerr matrix_x 0 ) ) (matrix_scalar_mul a (matrix-tail-noerr matrix_x 1 ) ) ) ))


 (define-bounded (matrix_scalar_div a matrix_x)
(if (< (matrix-length matrix_x ) 1 ) (matrix-empty ) (matrix-prepend (vec_scalar_div a (matrix-ref-noerr matrix_x 0 ) ) (matrix_scalar_div a (matrix-tail-noerr matrix_x 1 ) ) ) ))


 (define-bounded (scalar_matrix_sub a matrix_x)
(if (< (matrix-length matrix_x ) 1 ) (matrix-empty ) (matrix-prepend (scalar_vec_sub a (matrix-ref-noerr matrix_x 0 )) (scalar_matrix_sub a (matrix-tail-noerr matrix_x 1 )) ) ))


 (define-bounded (scalar_matrix_div a matrix_x)
(if (< (matrix-length matrix_x ) 1 ) (matrix-empty ) (matrix-prepend (scalar_vec_div a (matrix-ref-noerr matrix_x 0 )) (scalar_matrix_div a (matrix-tail-noerr matrix_x 1 )) ) ))


 (define-bounded (vec_elemwise_add x y)
(if (or (< (length x ) 1 ) (! (equal? (length x ) (length y ) ) ) ) (list-empty ) (list-prepend (+ (list-ref-noerr x 0 ) (list-ref-noerr y 0 ) ) (vec_elemwise_add (list-tail-noerr x 1 ) (list-tail-noerr y 1 ) ) ) ))


 (define-bounded (vec_elemwise_sub x y)
(if (or (< (length x ) 1 ) (! (equal? (length x ) (length y ) ) ) ) (list-empty ) (list-prepend (- (list-ref-noerr x 0 ) (list-ref-noerr y 0 ) ) (vec_elemwise_sub (list-tail-noerr x 1 ) (list-tail-noerr y 1 ) ) ) ))


 (define-bounded (vec_elemwise_mul x y)
(if (or (< (length x ) 1 ) (! (equal? (length x ) (length y ) ) ) ) (list-empty ) (list-prepend (* (list-ref-noerr x 0 ) (list-ref-noerr y 0 ) ) (vec_elemwise_mul (list-tail-noerr x 1 ) (list-tail-noerr y 1 ) ) ) ))


 (define-bounded (vec_elemwise_div x y)
(if (or (< (length x ) 1 ) (! (equal? (length x ) (length y ) ) ) ) (list-empty ) (list-prepend (quotient-noerr (list-ref-noerr x 0 ) (list-ref-noerr y 0 ) ) (vec_elemwise_div (list-tail-noerr x 1 ) (list-tail-noerr y 1 ) ) ) ))


 (define-bounded (matrix_elemwise_add matrix_x matrix_y)
(if (or (< (matrix-length matrix_x ) 1 ) (! (equal? (matrix-length matrix_x ) (matrix-length matrix_y ) ) ) ) (matrix-empty ) (matrix-prepend (vec_elemwise_add (matrix-ref-noerr matrix_x 0 ) (matrix-ref-noerr matrix_y 0 ) ) (matrix_elemwise_add (matrix-tail-noerr matrix_x 1 ) (matrix-tail-noerr matrix_y 1 ) ) ) ))


 (define-bounded (matrix_elemwise_sub matrix_x matrix_y)
(if (or (< (matrix-length matrix_x ) 1 ) (! (equal? (matrix-length matrix_x ) (matrix-length matrix_y ) ) ) ) (matrix-empty ) (matrix-prepend (vec_elemwise_sub (matrix-ref-noerr matrix_x 0 ) (matrix-ref-noerr matrix_y 0 ) ) (matrix_elemwise_sub (matrix-tail-noerr matrix_x 1 ) (matrix-tail-noerr matrix_y 1 ) ) ) ))


 (define-bounded (matrix_elemwise_mul matrix_x matrix_y)
(if (or (< (matrix-length matrix_x ) 1 ) (! (equal? (matrix-length matrix_x ) (matrix-length matrix_y ) ) ) ) (matrix-empty ) (matrix-prepend (vec_elemwise_mul (matrix-ref-noerr matrix_x 0 ) (matrix-ref-noerr matrix_y 0 ) ) (matrix_elemwise_mul (matrix-tail-noerr matrix_x 1 ) (matrix-tail-noerr matrix_y 1 ) ) ) ))


 (define-bounded (matrix_elemwise_div matrix_x matrix_y)
(if (or (< (matrix-length matrix_x ) 1 ) (! (equal? (matrix-length matrix_x ) (matrix-length matrix_y ) ) ) ) (matrix-empty ) (matrix-prepend (vec_elemwise_div (matrix-ref-noerr matrix_x 0 ) (matrix-ref-noerr matrix_y 0 ) ) (matrix_elemwise_div (matrix-tail-noerr matrix_x 1 ) (matrix-tail-noerr matrix_y 1 ) ) ) ))

(define-grammar (matmul_sca_inv0_gram agg.result i j m matA n ref.tmp row_vec val)
 [rv (choose (&& (&& (>= i 0 ) (<= i m ) ) (equal? agg.result (v0) ) ))]
[v0 (choose (v1))]
[v1 (choose (matrix-col-slice-noerr (matrix-row-slice-noerr matA (v2) (v2) ) (v2) (v2) ) (matrix-transpose-noerr (matrix-col-slice-noerr (matrix-row-slice-noerr matA (v2) (v2) ) (v2) (v2) ) ))]
[v2 (choose (v3))]
[v3 (choose 0 m n i val)]
)

(define-grammar (matmul_sca_inv1_gram j m matA n ref.tmp row_vec val agg.result i)
 [rv (choose (&& (&& (&& (&& (&& (>= i 0 ) (< i m ) ) (>= j 0 ) ) (<= j n ) ) (equal? row_vec (v0) ) ) (equal? agg.result (v4) ) ))]
[v0 (choose (matrix-ref-noerr (v1) (v2) ))]
[v1 (choose (matrix-col-slice-noerr (matrix-row-slice-noerr matA (v2) (v2) ) (v2) (v2) ) (matrix-transpose-noerr (matrix-col-slice-noerr (matrix-row-slice-noerr matA (v2) (v2) ) (v2) (v2) ) ))]
[v2 (choose (v3))]
[v3 (choose 0 m n i j val)]
[v4 (choose (v1))]
)

(define-grammar (matmul_sca_ps_gram matA val m n matmul_sca_rv)
 [rv (choose (equal? matmul_sca_rv (v0) ))]
[v0 (choose (v1))]
[v1 (choose (matrix-col-slice-noerr (matrix-row-slice-noerr matA (v2) (v2) ) (v2) (v2) ) (matrix-transpose-noerr (matrix-col-slice-noerr (matrix-row-slice-noerr matA (v2) (v2) ) (v2) (v2) ) ))]
[v2 (choose (v3))]
[v3 (choose 0 m n val)]
)

(define-grammar (map_int_to_int_gram int_x)
 [rv (choose (v0))]
[v0 (choose (integer-exp-noerr int_x ) (integer-sqrt-noerr int_x ))]
)

(define (matmul_sca_inv0 agg.result i j m matA n ref.tmp row_vec val) (matmul_sca_inv0_gram agg.result i j m matA n ref.tmp row_vec val #:depth 10))
(define (matmul_sca_inv1 j m matA n ref.tmp row_vec val agg.result i) (matmul_sca_inv1_gram j m matA n ref.tmp row_vec val agg.result i #:depth 10))
(define (matmul_sca_ps matA val m n matmul_sca_rv) (matmul_sca_ps_gram matA val m n matmul_sca_rv #:depth 10))

(define (map_int_to_int int_x) (map_int_to_int_gram int_x #:depth 10))

(define-symbolic agg.result_BOUNDEDSET-len integer?)
(define-symbolic agg.result_BOUNDEDSET-0 integer?)
(define-symbolic agg.result_BOUNDEDSET-1 integer?)
(define-symbolic agg.result_BOUNDEDSET-2 integer?)
(define-symbolic agg.result_BOUNDEDSET-3 integer?)
(define agg.result (take (list (list agg.result_BOUNDEDSET-0 agg.result_BOUNDEDSET-1) (list agg.result_BOUNDEDSET-2 agg.result_BOUNDEDSET-3)) agg.result_BOUNDEDSET-len))
(define-symbolic i integer?)
(define-symbolic j integer?)
(define-symbolic m integer?)
(define-symbolic matA_BOUNDEDSET-len integer?)
(define-symbolic matA_BOUNDEDSET-0 integer?)
(define-symbolic matA_BOUNDEDSET-1 integer?)
(define-symbolic matA_BOUNDEDSET-2 integer?)
(define-symbolic matA_BOUNDEDSET-3 integer?)
(define matA (take (list (list matA_BOUNDEDSET-0 matA_BOUNDEDSET-1) (list matA_BOUNDEDSET-2 matA_BOUNDEDSET-3)) matA_BOUNDEDSET-len))
(define-symbolic matmul_sca_rv_BOUNDEDSET-len integer?)
(define-symbolic matmul_sca_rv_BOUNDEDSET-0 integer?)
(define-symbolic matmul_sca_rv_BOUNDEDSET-1 integer?)
(define-symbolic matmul_sca_rv_BOUNDEDSET-2 integer?)
(define-symbolic matmul_sca_rv_BOUNDEDSET-3 integer?)
(define matmul_sca_rv (take (list (list matmul_sca_rv_BOUNDEDSET-0 matmul_sca_rv_BOUNDEDSET-1) (list matmul_sca_rv_BOUNDEDSET-2 matmul_sca_rv_BOUNDEDSET-3)) matmul_sca_rv_BOUNDEDSET-len))
(define-symbolic n integer?)
(define-symbolic ref.tmp integer?)
(define-symbolic row_vec_BOUNDEDSET-len integer?)
(define-symbolic row_vec_BOUNDEDSET-0 integer?)
(define-symbolic row_vec_BOUNDEDSET-1 integer?)
(define row_vec (take (list row_vec_BOUNDEDSET-0 row_vec_BOUNDEDSET-1) row_vec_BOUNDEDSET-len))
(define-symbolic val integer?)
(current-bitwidth 6)
(define (assertions)
 (assert (&& (&& (&& (&& (=> (&& (&& (&& (>= m 1 ) (>= n 1 ) ) (>= (matrix-length matA ) m ) ) (>= (length (matrix-ref-noerr matA 0 ) ) n ) ) (matmul_sca_inv0 (matrix-empty ) 0 0 m matA n 0 (list-empty ) val) ) (=> (&& (&& (&& (&& (&& (< i m ) (>= m 1 ) ) (>= n 1 ) ) (>= (matrix-length matA ) m ) ) (>= (length (matrix-ref-noerr matA 0 ) ) n ) ) (matmul_sca_inv0 agg.result i j m matA n ref.tmp row_vec val) ) (matmul_sca_inv1 0 m matA n ref.tmp (list-empty ) val agg.result i) ) ) (=> (&& (&& (&& (&& (&& (&& (&& (< j n ) (< i m ) ) (>= m 1 ) ) (>= n 1 ) ) (>= (matrix-length matA ) m ) ) (>= (length (matrix-ref-noerr matA 0 ) ) n ) ) (matmul_sca_inv0 agg.result i j m matA n ref.tmp row_vec val) ) (matmul_sca_inv1 j m matA n ref.tmp row_vec val agg.result i) ) (matmul_sca_inv1 (+ j 1 ) m matA n (* (list-ref-noerr (matrix-ref-noerr matA i ) j ) val ) (list-append row_vec (* (list-ref-noerr (matrix-ref-noerr matA i ) j ) val ) ) val agg.result i) ) ) (=> (&& (&& (&& (&& (&& (&& (&& (! (< j n ) ) (< i m ) ) (>= m 1 ) ) (>= n 1 ) ) (>= (matrix-length matA ) m ) ) (>= (length (matrix-ref-noerr matA 0 ) ) n ) ) (matmul_sca_inv0 agg.result i j m matA n ref.tmp row_vec val) ) (matmul_sca_inv1 j m matA n ref.tmp row_vec val agg.result i) ) (matmul_sca_inv0 (matrix-append agg.result row_vec ) (+ i 1 ) j m matA n ref.tmp row_vec val) ) ) (=> (or (&& (&& (&& (&& (&& (! (< i m ) ) (>= m 1 ) ) (>= n 1 ) ) (>= (matrix-length matA ) m ) ) (>= (length (matrix-ref-noerr matA 0 ) ) n ) ) (matmul_sca_inv0 agg.result i j m matA n ref.tmp row_vec val) ) (&& (&& (&& (&& (&& (&& (! true ) (! (< i m ) ) ) (>= m 1 ) ) (>= n 1 ) ) (>= (matrix-length matA ) m ) ) (>= (length (matrix-ref-noerr matA 0 ) ) n ) ) (matmul_sca_inv0 agg.result i j m matA n ref.tmp row_vec val) ) ) (matmul_sca_ps matA val m n agg.result) ) )))


    (define sol0
        (synthesize
            #:forall (list agg.result_BOUNDEDSET-len agg.result_BOUNDEDSET-0 agg.result_BOUNDEDSET-1 agg.result_BOUNDEDSET-2 agg.result_BOUNDEDSET-3 i j m matA_BOUNDEDSET-len matA_BOUNDEDSET-0 matA_BOUNDEDSET-1 matA_BOUNDEDSET-2 matA_BOUNDEDSET-3 matmul_sca_rv_BOUNDEDSET-len matmul_sca_rv_BOUNDEDSET-0 matmul_sca_rv_BOUNDEDSET-1 matmul_sca_rv_BOUNDEDSET-2 matmul_sca_rv_BOUNDEDSET-3 n ref.tmp row_vec_BOUNDEDSET-len row_vec_BOUNDEDSET-0 row_vec_BOUNDEDSET-1 val)
            #:guarantee (assertions)
        )
    )
    (sat? sol0)
    (print-forms sol0)