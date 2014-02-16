# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work, except classes 
#         from 'Containers' supplied by Kanwei Li in the 
#         'algorithms' rubygem 
#         <https://github.com/kanwei/algorithms>.

=begin
  Graph consists of functions that can be applied to graphs to 
  obtain useful results, such as distance between two points 
  on a graph (e.g. a matrix).
  
=end

# The bread-and-butter. A modified version of Dijkstra's Algorithm 
# <http://en.wikipedia.org/wiki/Dijkstra%27s_algorithm>
# that returns the path of least-resistance from a source to a 
# target in a graph.
#
#   t = Tree.new("C1,8R1+4;R1-2C2C1+4;")
#   visitor = TreeNodeVisitor.new
#   t.accept(visitor)
#   t.create_matrix     #=> [[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
#   t.transform_matrix  #=> [[8,4,0,0,0,0,0,4,0],[4,4,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
#   t.print_matrix      #=> 840000040
#                           440000000
#                           000000000
#   Dijkstra(visitor.matrix, center, top-left) #=> [[1,4],[0,4],[0,3],[0,2],[0,1],[0,0]]
def Dijkstra(graph, source, target)
  number_of_rows = graph.size
  number_of_columns = graph[0].size

  # if source out of range
  if source[0] >= number_of_rows || source[0] < 0
    return []
  end
  if source[1] >= number_of_columns || source[1] < 0
    return []
  end

  # creating a min priority queue 
  # max queue can be created by passing block { |x, y| (x <=> y) == 1 }
  min_priority_queue = Containers::PriorityQueue.new { |x, y| (x <=> y) == -1 }

  # initializations
  dist = Hash.new
  dist[source] = 0
  previous = Hash.new
  for i in 0...number_of_rows
    for j in 0...number_of_columns
      vertex = [i, j]
      if vertex != source
        dist[vertex] = (1 << 32) # a laaaaarge number
        previous[vertex] = nil # predecessor of vertex
      end
      min_priority_queue.push(vertex, dist[vertex])
    end
  end

  # main loop
  while !min_priority_queue.empty?
    u = min_priority_queue.pop
    if u == target
      break
    end
    # for each neighbour v of u
    neighbours(u, graph).each do |v|
      alt = dist[u] + length(u, v, graph)
      if alt < dist[v] && closer?(v, u, target)
        dist[v] = alt
        previous[v] = u
        # create new queue with updated priority
        new_queue = Containers::PriorityQueue.new { |x, y| (x <=> y) == -1 }
        dist.each {|object, priority|
          if object != u 
            new_queue.push(object, priority)
          end
        }
        # assign to old queue
        min_priority_queue = new_queue
      end
    end
  end

  # reverse iterate through previous to build path
  stack = Containers::Stack.new
  temp = target
  while previous[temp] != nil
    stack.push(temp)
    temp = previous[temp]
  end
  path = [source] # path starts at source
  while !stack.empty?
    path << stack.pop
  end

  return path
end

# Returns true if v is closer to target than u.
# Returns false otherwise.
#
# 0|          * target
# 1|
# 2|
# 3|  v *     * u
#   -----------
#   0 1 2 3 4 5
# 
#   v = [3,2]
#   u = [3,5]
#   target = [0,5]
#   closer?(v, u, target) #=> false
def closer?(v, u, target)
  if distance(v, target) < distance(u, target)
    return true
  end
  return false
end

# Returns the distance between two points on a graph.
def distance(u, v)
  x_diff = (v[0] - u[0])
  y_diff = (v[1] - u[1])
  return  Math.sqrt((x_diff ** 2) + (y_diff ** 2))
end

# Returns the added weights between two neighbouring points 
# on a graph, assuming u and v have weights associated with
# them represented as their respective values on the graph.
#
# 0|          
# 1|
# 2|
# 3|  v 5 1 u
#   -----------
#   0 1 2 3 4 5
#
# v has weight 5, u has weight 1. v and u are neighbours and 
# thus the relative "length" between them is 5 + 1 = 6. 
def length(u, v, graph)
  if !neighbour?(u, v)
    return 
  end
  return graph[u[0]][u[1]] + graph[v[0]][v[1]]
end

# Returns true if u is a neighbour of v. Returns false otherwise.
def neighbour?(u, v)
  x_diff = (u[1] - v[1]).abs
  y_diff = (u[0] - v[0]).abs
  if y_diff < 2 && x_diff < 2 && (x_diff + y_diff) == 1
    return true
  end
  return false
end

# Returns a list of neighbours orthogonal to u on graph.
def neighbours(u, graph)
  arr = []
  number_of_rows = graph.size
  number_of_columns = graph[0].size

  if u[0] >= number_of_rows || u[0] < 0
    return arr
  end
  if u[1] >= number_of_columns || u[1] < 0
    return arr
  end
  
  for i in 0...number_of_rows
    for j in 0...number_of_columns
      if neighbour?(u, [i, j])
        arr << [i, j]
      end 
    end
  end

  return arr
end

# Returns the cost of a given path on the graph.
#
# Let graph be:
#
# 0|          
# 1|
# 2|    v u x y
# 3|    5 1 4 0
#   -----------
#   0 1 2 3 4 5
#
#   path_cost([[3,2],[3,3],[3,4],[3,5]], graph) #=> 10
def path_cost(arr, graph)
  sum = 0
  arr.each do |element|
    x = element[0]
    y = element[1]
    sum = sum + graph[x][y]
  end
  return sum
end