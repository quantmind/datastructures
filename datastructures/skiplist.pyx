import cython

import numpy as np

from numpy cimport ndarray


@cython.internal
cdef class SlNode:

    cdef public:
        double value
        list next
        ndarray width_arr

    cdef:
        int *width

    def __cinit__(self, double value, list next, ndarray width):
        self.value = value
        self.next = next
        self.width_arr = width
        self.width = <int *> width.data


cdef int MAX_LEVELS = 30
cdef SlNode NIL = SlNode(np.inf, [], np.array([])) # Singleton terminator node


cdef class Skiplist:
    '''
    Sorted collection supporting O(lg n) insertion, removal, and lookup by rank.
    '''
    cdef readonly:
        int size, maxlevels
        SlNode head

    def __repr__(self):
        return list(self).__repr__()

    def __str__(self):
        return self.__repr__()

    def __cinit__(self, object values):
        self.size = 0
        self.maxlevels = MAX_LEVELS
        self.head = SlNode(np.NaN, [NIL] * self.maxlevels,
                           np.ones(self.maxlevels, dtype=int))
        if values:
            self.extend(values)

    def __len__(self):
        return self.size
