Data Structures
===================


|ci|


Binary Tree
--------------

A `binary tree`_ implementation is available:

.. code:: python

    from datastructures import Tree, Node

    tree = Tree()
    tree.size()        // 0
    tree.max_depth()   // 0
    tree.root          // None
    root = tree.add()  // Node
    root.left = Node()
    tree.size()        // 2
    tree.max_depth()   // 2

To check if the tree is a `binary search tree`_:

.. code:: python

    tree.is_bst()


.. |ci| image:: https://travis-ci.org/quantmind/datastructures.svg?branch=master
  :target: https://travis-ci.org/quantmind/datastructures
.. _`binary tree`: https://en.wikipedia.org/wiki/Binary_tree
.. _`binary search tree`: https://en.wikipedia.org/wiki/Binary_search_tree
