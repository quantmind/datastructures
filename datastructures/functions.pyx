from numpy cimport ndarray


cpdef long long factorial(long long n, long long n0=1):
    return _factorial(n, n0)


cpdef int permutations(int n, int k):
    cdef ndarray cache = ndarray([n])
    cdef int i, j

    assert k <= n, "k must be less or equal N"
    if k == n or k == 0:
        return 1
    elif k == n-1 or k == 1:
        return n

    cache[0] = 1
    cache[1] = 1
    i = 1
    while i < n:
        i += 1
        j = 1
        while j < i:
            cache[j - 1] += cache[j]
            j += 1
        cache[1:] = cache[0:-1]
        cache[0] = 1

    return cache[k]


cdef long long _factorial(long long n, long long s):
    if n < s:
        return 1
    return n * _factorial(n - 1, s)


cpdef long long factorial2(long long n):
    """Slower implementation without recursion
    """
    cdef long long i = 1
    cdef long long result = 1

    if n < 1:
        result = 1
    else:
        while i <= n:
            result *= i
            i += 1

    return result
