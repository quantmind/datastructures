

cdef class Node:

    cdef public:
        Node left, right
        double value

    def __cint__(self, double value=0):
        self.value = value


cdef class Tree:

    cdef readonly:
        Node root

    cpdef int size(self):
        return self.traverse()

    cpdef traverse(self, object callback=None):
        """Traverse a binary tree without recursion
        """
        cdef Node current = self.root
        cdef int processed = 0
        cdef count = 0
        cdef list stack = []

        while current:
            if not processed:
                count += 1
                if callback:
                    try:
                        callback(current, stack)
                    except StopIteration:
                        break
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

        return count


class CheckOrder:

    def __init__(self):
        self.max = None
        self.min = None
        self.result = True

    def __call__(self, node, stack):
        if not stack:
            self.max = node.data
            self.min = node.data
        else:
            prev = stack[-1]
            # left branch
            if prev.left is node:
                self.max = min(self.max, node.data)
                if node.data > self.max:
                    self.result = False
                    raise StopIteration
            # right branch
            elif prev.right is node:
                self.min
                if self.prev.data > node.data:
                    self.result = False
                    raise StopIteration
