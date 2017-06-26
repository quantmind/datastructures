from random import random

import cython

import numpy as np
from numpy cimport ndarray

from structures cimport Log2


@cython.internal
cdef class SlNode:

    def __cinit__(self, double value, list next, ndarray width):
        self.value = value
        self.next = next
        self.width_arr = width
        self.width = <int *> width.data


cdef int MAX_LEVELS = 30
cdef SlNode NIL = SlNode(np.inf, [], np.array([])) # Singleton terminator node


cdef class Skiplist:
    """Sorted collection supporting O(lg n) insertion,
    removal, and lookup by rank.
    """
    def __cinit__(self, object values=None, int maxlevels=0):
        self.size = 0
        self.maxlevels = maxlevels or MAX_LEVELS
        self.head = SlNode(np.NaN, [NIL] * self.maxlevels,
                           np.ones(self.maxlevels, dtype=int))
        if values:
            self.extend(values)

    def __repr__(self):
        return list(self).__repr__()

    def __str__(self):
        return self.__repr__()

    def __len__(self):
        return self.size

    def __iter__(self):
        cdef SlNode node = self.head.next[0]
        while node is not NIL:
            yield node.value
            node = node.next[0]

    cpdef void extend(self, object iterable):
        for v in iterable:
            self.insert(v)

    cpdef void insert(self, float value):
        cdef int level, steps, d
        cdef SlNode node, prevnode, newnode, next_at_level
        cdef list chain, steps_at_level

        # find first node on each level where node.next[levels].value > value
        chain = [None] * self.maxlevels
        steps_at_level = [0] * self.maxlevels

        node = self.head
        for level in range(self.maxlevels - 1, -1, -1):
            next_at_level = node.next[level]

            while next_at_level.value <= value:
                steps_at_level[level] = (steps_at_level[level] +
                                         node.width[level])
                node = next_at_level
                next_at_level = node.next[level]

            chain[level] = node

        # insert a link to the newnode at each level
        d = min(self.maxlevels, 1 - int(Log2(random())))
        newnode = SlNode(value, [None] * d, np.empty(d, dtype=int))
        steps = 0

        for level in range(d):
            prevnode = chain[level]

            newnode.next[level] = prevnode.next[level]
            prevnode.next[level] = newnode

            newnode.width[level] = prevnode.width[level] - steps
            prevnode.width[level] = steps + 1

            steps = steps + steps_at_level[level]

        for level in range(d, self.maxlevels):
            (<SlNode> chain[level]).width[level] += 1

        self.size += 1
