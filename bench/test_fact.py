import unittest

from math import factorial as factorial_stdlib
from datastructures.structures import factorial, factorial2


def fact(n):
    if n < 1:
        return n
    return n * fact(n - 1)


def fib(n):
    if n < 2:
        return n
    a, b, i = 1, 1, 1
    while i < n:
        i += 1
        a, b = b, b + a
    return b


def py_permutations(n, k):
    assert k <= n, "k must be less or equal N"
    if k == n or k == 0:
        return 1
    elif k == n - 1 or k == 1:
        return n
    cache = [1]*n
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


class FactorialBench(unittest.TestCase):
    __benchmark__ = True
    __number__ = 1000

    def test_factorial(self):
        """recursive factorial"""
        factorial(100000)

    def test_factorial2(self):
        """loop factorial"""
        factorial2(100000)

    def _test_factorial_stdlib(self):
        """recursive factorial"""
        factorial_stdlib(900)

    def _test_py_factorial(self):
        fact(900)

    def _test_py(self):
        fib(900)
