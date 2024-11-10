def kernel_2mm(ni: int, nj: int, nk: int, nl: int,
		alpha: int,
		beta: int,
		tmp: List[List[int]],
		A: List[List[int]],
		B: List[List[int]],
		C: List[List[int]],
		D: List[List[int]]) -> List[List[int]]:
    return_var = matrix_elemwise_add(matrix_scalar_mul(beta, D), matrix_elemwise_mul(matrix_elemwise_mul(matrix_scalar_mul(alpha, A),B),C))
    return return_var
