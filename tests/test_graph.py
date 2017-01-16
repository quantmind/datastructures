import unittest

from datastructures import Graph, GraphSearch


class TestGraph(unittest.TestCase):

    def test_journey_to_the_moon(self):
        graph = Graph()
        graph.extend_edges(
            [(0, 2), (1, 8), (1, 4), (2, 8), (2, 6), (3, 5), (6, 9)]
        )
        self.assertEqual(len(graph.vertices), 9)
        self.assertEqual(graph.vertices[2].degree(), 3)

        search = GraphSearch(graph)
        self.assertEqual(search.graph, graph)
        parents = search.bfs()
        self.assertEqual(len(parents), 7)
        self.assertEqual(parents[0], None)
        self.assertFalse(3 in parents)
        self.assertFalse(5 in parents)
        search = GraphSearch(graph, 3)
        p2 = search.bfs()
        self.assertEqual(len(p2), 2)
        #
        # Solve problem
        processed = set()
        countries = []
        rest = [0]
        total = 0
        while rest:
            country = set(GraphSearch(graph, rest[0]).bfs())
            countries.append(country)
            processed.update(country)
            rest = tuple(set(graph.vertices) - processed)

        for i, country in enumerate(countries, 1):
            total += len(country)*(10 - len(processed))
            for other in countries[i:]:
                total += len(country)*len(other)

        self.assertEqual(len(countries), 2)
        self.assertEqual(total, 23)
