NI = 10
NJ = 20
NK = 30
NL = 40

def kernel_2mm(ni: int, nj: int, nk: int, nl: int, alpha: int, beta: int, tmp: List[List[int]], A: List[List[int]], B: List[List[int]], C: List[List[int]], D: List[List[int]]) -> List[List[int]]:
    return matrix_elemwise_add(matrix_scalar_mul(beta,D), matrix_elemwise_mul(matrix_scalar_mul(alpha, matrix_elemwise_mul(A,B)),C))



D = [[(i*(j+2) % NK) // NK for j in range(NL)] for i in range(NI)]
A = [[(i*j+1) % NI // NI for j in range(NK)] for i in range(NI)]
B = [[i*(j+1) % NJ // NJ for j in range(NJ)] for i in range(NK)]
C = [[(i*(j+3)+1) % NL // NL for j in range(NL)] for i in range(NJ)]
tmp = [[0 for j in range(NJ)] for i in range(NI)]
alpha= 1.5
beta=1.2

return_var = kernel_2mm(NI, NJ, NK, NL, alpha, beta, tmp, A, B, C, D)