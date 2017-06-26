import unittest

from datastructures import Graph


class TestGraph(unittest.TestCase):

    def test_bfs(self):
        graph = Graph()
        graph.extend_edges(
            [(0, 2), (1, 8), (1, 4), (2, 8), (2, 6), (3, 5), (6, 9)]
        )
        self.assertEqual(len(graph.vertices), 9)
        self.assertEqual(graph.vertices[2].degree(), 3)

        search = graph.bfs(0)
        self.assertEqual(search.graph, graph)
        self.assertEqual(len(search.parents), 7)
        self.assertEqual(search.parents[0], None)
        self.assertFalse(3 in search.parents)
        self.assertFalse(5 in search.parents)
        #
        search2 = graph.bfs(3)
        self.assertEqual(len(search2.parents), 2)

    def test_dijsktra(self):
        pass
