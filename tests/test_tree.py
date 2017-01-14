import unittest

from datastructures import Tree


class TestTree(unittest.TestCase):

    def test_empty_tree(self):
        tree = Tree()
        self.assertEqual(tree.size(), 0)
        self.assertEqual(tree.max_depth(), 0)
        self.assertEqual(list(tree), [])

    def test_root(self):
        tree = Tree()
        root = tree.add()
        self.assertEqual(root, tree.root)
        self.assertEqual(tree.size(), 1)
        self.assertEqual(tree.max_depth(), 1)
        self.assertEqual(list(tree), [root])
