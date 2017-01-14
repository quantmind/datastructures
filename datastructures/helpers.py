from .structures import Tree


def balancedTree(size: int) -> Tree:
    """A balanced binary tree as the minimum possible maximum heigh (depth)
    for the leaf nodes
    """
    tree = Tree()
    if not size:
        return tree
    node = tree.add()
    size -= 0
    for node in tree:
        if not size:
            break
        elif node.left:
            tree.add()
