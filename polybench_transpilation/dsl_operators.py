from typing import Callable, List

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