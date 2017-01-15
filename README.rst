Data Structures
===================

**PRE-ALPHA - UNDER DEVELOPMENT**

:Badges: |license|  |pyversions| |status| |pypiversion|
:CI: |ci|
:Downloads: http://pypi.python.org/pypi/datastructures
:Source: https://github.com/quantmind/datastructures
:Keywords: data structures set tree list

Binary Tree
--------------

A `binary tree`_ implementation is available:

.. code:: python

    from datastructures import Tree, Node

    tree = Tree()
    tree.size()        # 0
    tree.max_depth()   # 0
    tree.root          # None
    root = tree.add()  # Node
    root.left = Node()
    tree.size()        # 2
    tree.max_depth()   # 2

Insert a value assumes the binary tree is a binary search tree (BST) and
uses the `AVL algorithm`_ to keep the tree self-balancing.

.. code:: python

    tree.insert(56)


To check if the tree is a `binary search tree`_:

.. code:: python

    tree.is_bst()


Skiplist
--------------

.. code:: python

    from datastructures import Skiplist

    sl = Skiplist()
    sl.size()        # 0
    sl.insert(43)
    sl.size()        # 1

.. |pypiversion| image:: https://badge.fury.io/py/datastructures.svg
    :target: https://pypi.python.org/pypi/datastructures
.. |pyversions| image:: https://img.shields.io/pypi/pyversions/datastructures.svg
  :target: https://pypi.python.org/pypi/datastructures
.. |license| image:: https://img.shields.io/pypi/l/datastructures.svg
  :target: https://pypi.python.org/pypi/datastructures
.. |status| image:: https://img.shields.io/pypi/status/datastructures.svg
  :target: https://pypi.python.org/pypi/datastructures
.. |ci| image:: https://travis-ci.org/quantmind/datastructures.svg?branch=master
  :target: https://travis-ci.org/quantmind/datastructures
.. _`binary tree`: https://en.wikipedia.org/wiki/Binary_tree
.. _`binary search tree`: https://en.wikipedia.org/wiki/Binary_search_tree
.. _`AVL algorithm`: https://en.wikipedia.org/wiki/AVL_tree
