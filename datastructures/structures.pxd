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
    cdef int _size, maxlevels
    cdef SlNode head

    cpdef int size(self)
    cpdef void insert(self, float value)
    cpdef void extend(self, object iterable)


cdef extern from "math.h":
    double log(double x)
    double sqrt(double x)


cdef inline double Log2(double x):
    return log(x) / log(2.)
