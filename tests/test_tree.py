import os
import unittest

from datastructures import Tree, loadTree


CASES = os.path.join(os.path.dirname(__file__), 'cases')


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
        self.assertEqual(list((n.node for n in tree)), [root])
        self.assertEqual(list((n.node for n in tree.inorder())), [root])
        self.assertFalse(root.left)
        self.assertFalse(root.right)

    def test_add(self):
        tree = Tree()
        root = tree.add()
        self.assertEqual(tree.add(), root.left)
        self.assertEqual(tree.size(), 2)
        self.assertEqual(tree.max_depth(), 2)
        self.assertEqual(tree.add(), root.right)
        self.assertEqual(tree.size(), 3)
        self.assertEqual(tree.max_depth(), 2)

    def test_iterables(self):
        tree = loadTree(os.path.join(CASES, 'tree1.txt'))
        self.assertEqual(tree.size(), 11)
        self.assertEqual(tree.max_depth(), 5)
        nodes = ' '.join((str(int(n.node.value)) for n in tree))
        self.assertEqual(nodes, '1 2 4 6 9 3 5 7 8 10 11')
        nodes = ' '.join((str(int(n.node.value)) for n in tree.inorder()))
        self.assertEqual(nodes, '6 9 4 2 1 7 5 10 8 11 3')
