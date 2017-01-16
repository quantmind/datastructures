from collections import deque


cdef class Vertex:
    cdef readonly:
        int id
        float score

    cdef set _links

    def __cinit__(self, int id, float score=1):
        self.id = id
        self._links = set()
        self.score = score

    def __repr__(self):
        return '%s' % self.id

    def __str__(self):
        return self.__repr__()

    @property
    def neighbors(self):
        return tuple(self._links)

    cpdef void add_link(self, int id):
        if id != self.id:
            self._links.add(id)

    cpdef int degree(self):
        return len(self._links)

    def links(self):
        return iter(self._links)


cdef class Graph:

    cdef readonly:
        object directed
        dict vertices

    def __init__(self, object edges=None, object directed=False):
        self.vertices = {}
        self.directed = directed
        if edges:
            self.extend_edges(edges)

    cpdef void extend_edges(self, object edges):
        cdef int id1, id2

        for edge in edges:
            id1 = edge[0]
            id2 = edge[1]
            if id1 not in self.vertices:
                self.vertices[id1] = Vertex(id1)
            if id2 not in self.vertices:
                self.vertices[id2] = Vertex(id2)
            self.vertices[id1].add_link(self.vertices[id2].id)
            if not self.directed:
                self.vertices[id2].add_link(self.vertices[id1].id)


cdef class GraphSearch:
    """Search algorithms with callbacks
    """
    cdef public:
        Graph graph
        int root
        object finished
        dict parents

    def __cinit__(self, Graph g, int root=None):
        self.graph = g
        self.root = root or 0
        self.finished = False

    cpdef dict bfs(self):
        """Breadth-first search algorithm
        """
        cdef set visited = set()
        cdef set processed = set()
        cdef object queue = deque()
        cdef int vid
        cdef Vertex vertex, adj

        if self.parents is not None:
            raise RuntimeError('Search already consumed')

        self.parents = {}

        if not self.graph.vertices:
            return

        vertex = self.graph.vertices[self.root or 0]
        self.parents[vertex.id] = None

        queue.append(vertex)

        while queue:
            if self.finished:
                break

            vertex = queue.pop()
            if vertex not in processed:
                self.process_vertex_early(vertex)
                processed.add(vertex)
                for vid in vertex.links():
                    adj = self.graph.vertices[vid]

                    if adj in processed:
                        if self.graph.directed:
                            self.process_edge(vertex, adj)
                    else:
                        self.process_edge(vertex, adj)

                        if adj not in visited:
                            visited.add(adj)
                            queue.appendleft(adj)
                            self.parents[adj.id] = vertex.id

                self.process_vertex_late(vertex)

        return self.parents

    cpdef dict dfs(self):
        """Depth-first search algorithm
        """
        if self.parents is not None:
            raise RuntimeError('Search already consumed')
        self.parents = {}
        if self.graph.vertices:
            dfs(self, self.graph.vertices[self.root or 0])
        return self.parents


    cpdef void process_vertex_early(self, Vertex vertex):
        pass

    cpdef void process_vertex_late(self, Vertex vertex):
        pass

    cpdef void process_edge(self, Vertex parent, Vertex child):
        pass


cdef void dfs(GraphSearch search, Vertex vertex):
    """Depth-first search algorithm
    """
    cdef set visited = set()
    cdef set processed = set()
    cdef Vertex adj

    if search.finished:
        return

    search.process_vertex_early(vertex)
    for v in vertex.links():
        adj = search.graph.vertices[v]
        if adj not in visited:
            search.parents[adj.id] = adj
            search.process_edge(vertex, adj)
            dfs(search, adj)
        elif adj not in processed or search.graph.directed:
            search.process_edge(vertex, adj)
            if search.finished:
                return

    search.process_vertex_late(vertex)
    processed.add(vertex)

