import sys
from functools import reduce


cdef class Node:

    cdef public:
        Node left, right
        double value

    def __cinit__(self, double value=0):
        self.value = value

    @property
    def balanced(self):
        return self.left and self.right

    cpdef int max_depth(self):
        return max_depth(self)

    cpdef object is_bst(self):
        return is_bst(self)

    cpdef object insert(self, double value):
        insert(self, value)

    def __repr__(self):
        return 'BinaryTreeNode(%s)%s%s' % (
            self.value,
            ' left' if self.left else '',
            ' right' if self.right else ''
        )

    def __str__(self):
        return self.__repr__()

    def __iter__(self):
        """Traverse a binary tree without recursion
        """
        cdef Node current = self
        cdef int processed = 0
        cdef list stack = []

        while current:
            if not processed:
                yield TreeNode(current, stack)
                if current.left:
                    stack.append((current, 1))
                    current = current.left
                    processed = 0
                    continue

            if processed < 2:
                if current.right:
                    stack.append((current, 2))
                    current = current.right
                    processed = 0
                    continue

            # end of the tree
            try:
                current, processed = stack.pop()
            except IndexError:
                break

    def in_order(self):
        """Iterate the Tree in order
        """
        cdef Node current = self
        cdef int processed = 0
        cdef list stack = []

        while current:
            if not processed:
                if current.left:
                    stack.append((current, 1))
                    current = current.left
                    processed = 0
                    continue
                else:
                    processed = 1

            if processed == 1:
                yield TreeNode(current, stack)
                if current.right:
                    stack.append((current, 2))
                    current = current.right
                    processed = 0
                    continue

            # end of the tree
            try:
                current, processed = stack.pop()
            except IndexError:
                break

    def in_reversed_order(self):
        """Iterate the Tree in order
        """
        cdef Node current = self
        cdef int processed = 0
        cdef list stack = []

        while current:
            if not processed:
                if current.right:
                    stack.append((current, 1))
                    current = current.right
                    processed = 0
                    continue
                else:
                    processed = 1

            if processed == 1:
                yield TreeNode(current, stack)
                if current.left:
                    stack.append((current, 2))
                    current = current.left
                    processed = 0
                    continue

            # end of the tree
            try:
                current, processed = stack.pop()
            except IndexError:
                break


cdef class TreeNode:
    cdef readonly:
        Node node
        Node parent
        int depth

    def __cinit__(self, Node node, list stack):
        self.node = node
        self.parent = stack[-1][0] if stack else None
        self.depth = len(stack) + 1


cdef class Tree:
    """Binary Tree
    """
    cdef readonly:
        Node root

    cpdef int size(self):
        return reduce(count, self, 0)

    cpdef int max_depth(self):
        return max_depth(self.root)

    cpdef object is_bst(self):
        return is_bst(self.root) if self.root else True

    cpdef void insert(self, float value):
        if self.root:
            insert(self.root, value)
        else:
            self.root = Node(value)

    cpdef Node add(self, Node parent=None):
        """Add a new node to the tree
        """
        cdef Node node
        parent = parent or self.root

        if not parent:
            self.root = parent = Node()
            return parent

        if not parent.left:
            node = Node()
            parent.left = node
        elif not parent.right:
            node = Node()
            parent.right = node
        else:
            raise ValueError('cannot add node to %s' % parent)

        return node

    def __iter__(self):
        return iter(self.root if self.root else ())

    def in_order(self):
        return iter(self.root.in_order() if self.root else ())

    def in_reversed_order(self):
        return iter(self.root.in_reversed_order() if self.root else ())


cdef int count(a, b):
    return a + 1


cdef int max_depth(Node node):
    cdef int ld;
    cdef int rd;

    if not node:
        return 0

    ld = max_depth(node.left)
    rd = max_depth(node.right)
    if ld > rd:
        return ld + 1
    else:
        return rd + 1


cdef void insert(Node node, float value):
    while 1:
        if value > node.value:
            if node.right:
                node = node.right
                continue
            node.right = Node(value)
            break
        elif node.left:
            node = node.left
            continue
        else:
            node.left = Node(value)
            break


cdef int is_bst(Node root):
    cdef float prev =-float(sys.maxsize)
    cdef TreeNode node

    for node in root.in_order():
        if node.node.value < prev:
            return False
        prev = node.node.value

    return True
