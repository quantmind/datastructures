import unittest

from datastructures.structures import factorial, factorial2


class TestFunctions(unittest.TestCase):

    def test_factorial(self):
        self.assertEqual(factorial(0), 1)
        self.assertEqual(factorial(1), 1)
        self.assertEqual(factorial(2), 2)
        self.assertEqual(factorial(3), 6)
        self.assertEqual(factorial(4), 24)

    def test_factorial2(self):
        self.assertEqual(factorial2(0), 1)
        self.assertEqual(factorial2(1), 1)
        self.assertEqual(factorial2(2), 2)
        self.assertEqual(factorial2(3), 6)
        self.assertEqual(factorial2(4), 24)
