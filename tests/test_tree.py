import unittest

from datastructures import Tree


class TestTree(unittest.TestCase):

    def test_tree(self):
        tree = Tree()
        self.assertEqual(tree.size(), 0)
