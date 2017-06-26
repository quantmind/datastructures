from collections import deque


cdef class Vertex:
    cdef readonly:
        object id
        float score

    cdef set _links

    def __cinit__(self, object idv, float score=1):
        self.id = idv
        self._links = set()
        self.score = score

    def __repr__(self):
        return '%s' % self.id

    def __str__(self):
        return self.__repr__()

    @property
    def neighbors(self):
        return tuple(self._links)

    cpdef void add_link(self, object id):
        if id != self.id:
            self._links.add(id)

    cpdef int degree(self):
        return len(self._links)

    def links(self):
        return iter(self._links)


class GraphSearch:
    """Search algorithms with callbacks
    """
    def __init__(self, Graph g, object root):
        self.graph = g
        self.finished = False
        self.root = root
        self.parents = {root.id: None}
        self.visited = set()
        self.processed = set()

    def process_vertex_early(self, vertex):
        pass

    def process_vertex_late(self, vertex):
        pass

    def process_edge(self, parent, child):
        pass


cdef class Graph:

    cdef readonly:
        object directed
        object multiple_edges
        dict vertices

    def __init__(self, object edges=None, object directed=False,
                 object multiple_edges=False):
        self.vertices = {}
        self.directed = directed
        self.multiple_edges = multiple_edges
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

    cpdef object get_search(self, object root, search=None):
        if not self.vertices:
            raise ValueError('No vertices')
        if not isinstance(root, Vertex):
            root = self.vertices[root]
        if search is None:
            search = GraphSearch(self, root)
        return search

    cpdef object bfs(self, object root, search=None):
        """Breadth-first search algorithm
        """
        cdef object queue = deque()
        cdef int vid
        cdef Vertex vertex, adj

        search = self.get_search(root, search)

        queue.append(search.root)

        while queue:
            if search.finished:
                break

            vertex = queue.pop()
            if vertex not in search.processed:
                search.process_vertex_early(vertex)
                search.processed.add(vertex)
                for vid in vertex.links():
                    adj = self.vertices[vid]

                    if adj in search.processed:
                        if self.directed:
                            search.process_edge(vertex, adj)
                    else:
                        search.process_edge(vertex, adj)

                        if adj not in search.visited:
                            search.visited.add(adj)
                            queue.appendleft(adj)
                            search.parents[adj.id] = vertex.id

                search.process_vertex_late(vertex)

        return search

    cpdef object dfs(self, root, search=None):
        """Depth-first search algorithm
        """
        return dfs(self.get_search(root, search), search.root)

    cpdef object dijsktra(self, object root, search=None):
        """Dijsktra algorithm for finding the shortest
        paths from a staring root node
        """
        search = self.get_search(root, search)
        vertices = set(self.vertices.values())
        distances = {search.root: 0}

        while vertices:
            if search.finished:
                break

            vertex = None
            for node in vertices:
                if node in distances:
                    if vertex is None:
                        vertex = node
                    elif distances[node] < distances[vertex]:
                        vertex = node

            if vertex is None:
                break

            search.process_vertex_early(vertex)
            vertices.remove(vertex)

            current_weight = distances[vertex]

            for idv in vertex.links:
                adj = self.vertices[idv]
                weight = current_weight + search.distance(vertex, adj)
                if adj not in distances or weight < distances[adj]:
                    distances[adj] = weight
                    search.path[adj] = vertex
                    search.process_edge(vertex, adj)

            search.process_vertex_late(vertex)

        return search

    def shortest_path(self, start, end, search=None):
        pass


cdef object dfs(object search, Vertex vertex):
    """Depth-first search recursive implementation
    """
    cdef Vertex adj
    cdef Graph graph = search.graph

    if search.finished:
        return

    search.visited.add(vertex)
    search.process_vertex_early(vertex)

    for v in vertex.links():
        adj = graph.vertices[v]
        if adj not in search.visited:
            search.parents[adj.id] = adj
            search.process_edge(vertex, adj)
            dfs(search, adj)
        elif adj not in search.processed or graph.directed:
            search.process_edge(vertex, adj)
            if search.finished:
                return

    search.process_vertex_late(vertex)
    search.processed.add(vertex)
    return search

