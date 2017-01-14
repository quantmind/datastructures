

cpdef int factorial(int n):
    if n < 1:
        return n
    return n * factorial(n - 1)
