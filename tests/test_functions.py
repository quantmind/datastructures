import unittest

from datastructures.structures import factorial, factorial2, permutations


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

    def test_permutations(self):
        self.assertEqual(permutations(2, 2), 1)
        self.assertEqual(permutations(2, 1), 2)
        self.assertEqual(permutations(3, 2), 3)
        self.assertEqual(permutations(4, 2), 6)
        self.assertEqual(permutations(10, 4), 210)
