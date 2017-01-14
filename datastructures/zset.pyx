from structures cimport Skiplist


cdef class Zset:
    '''Ordered-set equivalent of redis zset.
    '''
    cdef dict dict
    cdef Skiplist sl

    def __cinit__(self, object data=None):
        self.sl = Skiplist()
        self.dict = {}

    def __repr__(self):
        return repr(self.sl)
    __str__ = __repr__

    def __len__(self):
        return len(self.dict)

    def __iter__(self):
        for _, value in self.sl:
            yield value

    def __getstate__(self):
        return self.dict

    def __setstate__(self, state):
        self.dict = state
        self.sl = Skiplist(((score, member) for member, score
                            in state.items()))

    def __richcmp__(self, other, op):
        if isinstance(other, Zset):
            if op == 2:
                return other.dict == self.dict
        return False

    def items(self):
        '''Iterable over ordered score, value pairs of this :class:`zset`
        '''
        return iter(self.sl)

    def range(self, start, end, scores=False):
        return self.sl.range(start, end, scores)

    def range_by_score(self, minval, maxval, include_min=True,
                       include_max=True, start=0, num=None, scores=False):
        return self.sl.range_by_score(minval, maxval, start=start,
                                      num=num, include_min=include_min,
                                      include_max=include_max,
                                      scores=scores)

    def score(self, member, default=None):
        '''The score of a given member'''
        return self.dict.get(member, default)

    def count(self, minval, maxval, include_min=True, include_max=True):
        return self.sl.count(minval, maxval, include_min, include_max)

    def add(self, score, val):
        r = 1
        if val in self.dict:
            sc = self.dict[val]
            if sc == score:
                return 0
            self.remove(val)
            r = 0
        self.dict[val] = score
        self.sl.insert((score, val))
        return r

    def update(self, score_vals):
        '''Update the :class:`zset` with an iterable over pairs of
scores and values.'''
        add = self.add
        for score, value in score_vals:
            add(score, value)

    def remove_items(self, items):
        removed = 0
        for item in items:
            score = self.remove(item)
            if score is not None:
                removed += 1
        return removed

    def remove(self, item):
        '''Remove ``item`` for the :class:`zset` it it exists.
        If found it returns the score of the item removed.
        '''
        score = self.dict.pop(item, None)
        if score is not None:
            index = self.sl.rank(score)
            assert index >= 0, 'could not find start range'
            for i, v in enumerate(self.sl.range(index)):
                if v == item:
                    assert self.sl.remove_range(index + i, index+i + 1) == 1
                    return score
            assert False, 'could not find element'

    def remove_range(self, start, end):
        '''Remove a range by score.
        '''
        return self.sl.remove_range(
            start, end, callback=lambda sc, value: self.dict.pop(value))

    def remove_range_by_score(self, minval, maxval,
                              include_min=True, include_max=True):
        '''Remove a range by score.
        '''
        return self.sl.remove_range_by_score(
            minval, maxval, include_min=include_min, include_max=include_max,
            callback=lambda sc, value: self.dict.pop(value))

    def clear(self):
        '''Clear this :class:`zset`.'''
        self.sl = Skiplist()
        self.dict.clear()

    def rank(self, item):
        '''Return the rank (index) of ``item`` in this :class:`zset`.'''
        score = self.dict.get(item)
        if score is not None:
            return self.sl.rank(score)

    def flat(self):
        return self.sl.flat()

    @classmethod
    def union(cls, zsets, weights, oper):
        result = None
        for zset, weight in zip(zsets, weights):
            if result is None:
                result = cls()
                sl = result.sl
                for score, value in zset.sl:
                    result.add(score*weight, value)
            else:
                for score, value in zset.sl:
                    score *= weight
                    existing = sl.score(value)
                    if existing is not None:
                        score = oper(score, existing)
                    result.add(score, value)
        return result

    @classmethod
    def inter(cls, zsets, weights, oper):
        result = None
        values = None
        for zset, _ in zip(zsets, weights):
            if values is None:
                values = set(zset)
            else:
                values.intersection_update(zset)
        #
        for zset, weight in zip(zsets, weights):
            if result is None:
                result = cls()
                for score, value in zset.sl:
                    if value in values:
                        result.add(score*weight, value)
            else:
                for score, value in zset.sl:
                    if value in values:
                        existing = result.score(value)
                        score = oper((score*weight, existing))
                        result.add(score, value)
        return result
