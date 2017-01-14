from numpy cimport ndarray


cdef class SlNode:

    cdef public:
        double value
        list next
        ndarray width_arr

    cdef int *width


cdef class Skiplist:
    '''
    Sorted collection supporting O(lg n) insertion, removal, and lookup by rank.
    '''
    cdef readonly:
        int size, maxlevels

    cdef SlNode head

    cpdef void insert(self, double value)


cdef extern from "math.h":
    double log(double x)
    double sqrt(double x)


cdef double clog2 = log(2.)


cdef inline double Log2(double x):
    return log(x) / clog2
