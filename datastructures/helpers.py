from .structures import Tree, Node


def loadTree(filename):
    with open(filename, 'r') as fp:
        lines = fp.read().split('\n')

    tree = Tree()

    created = {}

    for index, line in enumerate(lines):
        left_right_value = line.strip().split()
        if not left_right_value:
            break
        if not index:
            node = tree.add()
        else:
            node = created[index+1]

        if len(left_right_value) == 3:
            node.value = float(left_right_value.pop())
        else:
            node.value = index + 1

        left, right = left_right_value

        if left != '-1':
            node.left = Node()
            created[int(left)] = node.left

        if right != '-1':
            node.right = Node()
            created[int(right)] = node.right

    return tree
