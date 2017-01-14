import unittest

from datastructures import factorial


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


class FibonacciBench(unittest.TestCase):
    __benchmark__ = True
    __number__ = 1000

    def test_py_factorial(self):
        fact(900)

    def test_factorial(self):
        factorial(10000)

    def test_py(self):
        fib(900)
