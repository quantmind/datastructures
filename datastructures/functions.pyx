

cpdef int factorial(int n):
    return _factorial(n)


cpdef int factorial2(int n):
    cdef int i = 1
    cdef int result = 1

    if n < 1:
        result = 1
    else:
        while i <= n:
            result *= i
            i += 1

    return result


cdef int _factorial(int n):
    if n < 1:
        return 1
    return n * _factorial(n - 1)
