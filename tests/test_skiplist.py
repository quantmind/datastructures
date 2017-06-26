import unittest

from pulsar.apps.test import populate

from datastructures import Skiplist


class TestSkiplist(unittest.TestCase):

    def random(self, size=100, score_min=-10, score_max=10):
        scores = populate('float', size, score_min, score_max)
        return Skiplist(scores)

    def values(self, sl):
        return ' '.join((str(int(n)) for n in sl))

    def ordered(self, sl):
        prev = None
        for v in sl:
            if prev is not None:
                self.assertGreaterEqual(v, prev)
            prev = v

    def test_extend(self):
        sl = self.random()
        self.assertEqual(len(sl), 100)
        self.ordered(sl)

    def test_insert(self):
        sl = Skiplist()
        sl.insert(5)
        self.assertEqual(len(sl), 1)
        self.assertEqual(self.values(sl), '5')
        sl.insert(2)
        self.assertEqual(len(sl), 2)
        self.assertEqual(self.values(sl), '2 5')
        sl.insert(3)
        self.assertEqual(len(sl), 3)
        self.assertEqual(self.values(sl), '2 3 5')
        sl.insert(8)
        self.assertEqual(len(sl), 4)
        self.assertEqual(self.values(sl), '2 3 5 8')
        sl.insert(-1)
        self.assertEqual(len(sl), 5)
        self.assertEqual(self.values(sl), '-1 2 3 5 8')

    def test_iter(self):
        sl = self.random()
        data = list(sl)
        self.assertEqual(len(data), len(sl))
