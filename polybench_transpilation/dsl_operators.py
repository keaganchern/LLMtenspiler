from typing import List, Any


def matrix_elemwise_add(
    matrix_x: List[List[int]], matrix_y: List[List[int]]
) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1 or not len(matrix_x) == len(matrix_y)
        else [
            vec_elemwise_add(matrix_x[0], matrix_y[0]),
            *matrix_elemwise_add(matrix_x[1:], matrix_y[1:]),
        ]
    )

def matrix_elemwise_sub(
    matrix_x: List[List[int]], matrix_y: List[List[int]]
) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1 or not len(matrix_x) == len(matrix_y)
        else [
            vec_elemwise_sub(matrix_x[0], matrix_y[0]),
            *matrix_elemwise_sub(matrix_x[1:], matrix_y[1:]),
        ]
    )


def matrix_elemwise_mul(
    matrix_x: List[List[int]], matrix_y: List[List[int]]
) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1 or not len(matrix_x) == len(matrix_y)
        else [
            vec_elemwise_mul(matrix_x[0], matrix_y[0]),
            *matrix_elemwise_mul(matrix_x[1:], matrix_y[1:]),
        ]
    )


def matrix_elemwise_div(
    matrix_x: List[List[int]], matrix_y: List[List[int]]
) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1 or not len(matrix_x) == len(matrix_y)
        else [
            vec_elemwise_div(matrix_x[0], matrix_y[0]),
            *matrix_elemwise_div(matrix_x[1:], matrix_y[1:]),
        ]
    )

def matrix_scalar_add(a: int, matrix_x: List[List[int]]) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1
        else [vec_scalar_add(a, matrix_x[0]), *matrix_scalar_add(a, matrix_x[1:])]
    )

def matrix_scalar_sub(a: int, matrix_x: List[List[int]]) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1
        else [vec_scalar_sub(a, matrix_x[0]), *matrix_scalar_sub(a, matrix_x[1:])]
    )

def matrix_scalar_mul(a: int, matrix_x: List[List[int]]) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1
        else [vec_scalar_mul(a, matrix_x[0]), *matrix_scalar_mul(a, matrix_x[1:])]
    )


def matrix_scalar_div(a: int, matrix_x: List[List[int]]) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1
        else [vec_scalar_div(a, matrix_x[0]), *matrix_scalar_div(a, matrix_x[1:])]
    )

def scalar_matrix_div(a: int, matrix_x: List[List[int]]) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1
        else [scalar_vec_div(a, matrix_x[0]), *scalar_matrix_div(a, matrix_x[1:])]
    )

def scalar_matrix_sub(a: int, matrix_x: List[List[int]]) -> List[List[int]]:
    return (
        []
        if len(matrix_x) < 1
        else [scalar_vec_sub(a, matrix_x[0]), *scalar_matrix_sub(a, matrix_x[1:])]
    )

def scalar_vec_sub(a: int, x: List[int]) -> List[int]:
    return [] if len(x) < 1 else [(a - x[0]), *scalar_vec_sub(a, x[1:])]


def scalar_vec_div(a: int, x: List[int]) -> List[int]:
    return [] if len(x) < 1 else [(a // x[0]), *scalar_vec_div(a, x[1:])]


def vec_elemwise_add(x: List[int], y: List[int]) -> List[int]:
    return (
        []
        if len(x) < 1 or not len(x) == len(y)
        else [x[0] + y[0], *vec_elemwise_add(x[1:], y[1:])]
    )

def vec_elemwise_sub(x: List[int], y: List[int]) -> List[int]:
    return (
        []
        if len(x) < 1 or not len(x) == len(y)
        else [(x[0] - y[0]), *vec_elemwise_sub(x[1:], y[1:])]
    )

def vec_elemwise_mul(x: List[int], y: List[int]) -> List[int]:
    return (
        []
        if len(x) < 1 or not len(x) == len(y)
        else [x[0] * y[0], *vec_elemwise_mul(x[1:], y[1:])]
    )

def vec_elemwise_div(x: List[int], y: List[int]) -> List[int]:
    return (
        []
        if len(x) < 1 or not len(x) == len(y)
        else [(x[0] // y[0]), *vec_elemwise_div(x[1:], y[1:])]
    )



def vec_scalar_add(a: int, x: List[int]) -> List[int]:
    return [] if len(x) < 1 else [a + x[0], *vec_scalar_add(a, x[1:])]

def vec_scalar_sub(a: int, x: List[int]) -> List[int]:
    return [] if len(x) < 1 else [(x[0] - a), *vec_scalar_sub(a, x[1:])]


def vec_scalar_mul(a: int, x: List[int]) -> List[int]:
    return [] if len(x) < 1 else [a * x[0], *vec_scalar_mul(a, x[1:])]


def vec_scalar_div(a: int, x: List[int]) -> List[int]:
    return [] if len(x) < 1 else [(x[0] // a), *vec_scalar_div(a, x[1:])]

def matrix_vec_mul(matrix: List[List[int]], vector: List[int]) -> List[int]:
    return [sum(m * v for m, v in zip(row, vector)) for row in matrix]

def matrix_matrix_mul(matrix_a: List[List[int]], matrix_b: List[List[int]]) -> List[List[int]]:
    if not matrix_a:
        return []
    
    first_row_result = [
        sum(a * b for a, b in zip(matrix_a[0], col))
        for col in zip(*matrix_b)  
    ]
    
    return [first_row_result, *matrix_matrix_mul(matrix_a[1:], matrix_b)]

def list_get(lst: List[Any], index: int) -> Any:
    return lst[index]

def matrix_get(matrix: List[List[Any]], index: int) -> List[Any]:
    return matrix[index]

def list_append(lst: List[Any], element: Any) -> List[Any]:
    return lst + [element]

def matrix_append(matrix: List[List[Any]], row: List[Any]) -> List[List[Any]]:
    return matrix + [row]

def list_prepend(lst: List[Any], element: Any) -> List[Any]:
    return [element] + lst

def matrix_prepend(matrix: List[List[Any]], row: List[Any]) -> List[List[Any]]:
    return [row] + matrix

def list_concat(lst1: List[Any], lst2: List[Any]) -> List[Any]:
    return lst1 + lst2

def list_tail(lst: List[Any], start_index: int) -> List[Any]:
    return lst[start_index:]

def matrix_tail(matrix: List[List[Any]], start_index: int) -> List[List[Any]]:
    return matrix[start_index:]

def list_take(lst: List[Any], n: int) -> List[Any]:
    return lst[:n]

def matrix_take(matrix: List[List[Any]], n: int) -> List[List[Any]]:
    return matrix[:n]

def vec_slice(vec: List[Any], start: int, end: int) -> List[Any]:
    return vec[start:end]

def matrix_row_slice(matrix: List[List[Any]], start: int, end: int) -> List[List[Any]]:
    return matrix[start:end]

def vec_slice_with_length(vec: List[Any], start: int, length: int) -> List[Any]:
    return vec[start:start + length]

def matrix_row_slice_with_length(matrix: List[List[Any]], start: int, length: int) -> List[List[Any]]:
    return matrix[start:start + length]

def matrix_col_slice(matrix: List[List[Any]], start: int, end: int) -> List[List[Any]]:
    return [row[start:end] for row in matrix]

def matrix_col_slice_with_length(matrix: List[List[Any]], start: int, length: int) -> List[List[Any]]:
    return [row[start:start + length] for row in matrix]

def matrix_transpose(matrix: List[List[Any]]) -> List[List[Any]]:
    return [list(row) for row in zip(*matrix)]