# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work.

require 'rubygems'
require 'bundler/setup'
require 'algorithms'
require './lib/Visitable'
require './lib/TreeNode'
require './lib/IncrementNode'
require './lib/RowNode'
require './lib/ColumnNode'
require './lib/Tree'
require './lib/TreeNodePrintVisitor'
require './lib/TreeNodeVisitor'
require './lib/ParseTree'
require './lib/Graph'


input = gets.chomp # chomp gets rid of trailing newline
t = Tree.new(input)

visitor = TreeNodeVisitor.new

t.accept(visitor)
# t.accept(TreeNodePrintVisitor.new)   # will print out keywords of tree (R1,2 is a keyword)

visitor.create_matrix
visitor.transform_matrix
visitor.print_matrix

top_left = [0, 0]
top_right = [0, visitor.number_of_columns - 1]
bottom_left = [visitor.number_of_rows - 1, 0]
bottom_right = [visitor.number_of_rows - 1, visitor.number_of_columns - 1]
center = [visitor.number_of_rows/2, visitor.number_of_columns/2]

path_to_top_left = Dijkstra(visitor.matrix, center, top_left)
path_to_top_right = Dijkstra(visitor.matrix, center, top_right)
path_to_bottom_left = Dijkstra(visitor.matrix, center, bottom_left)
path_to_bottom_right = Dijkstra(visitor.matrix, center, bottom_right)

min_cost_to_top_left = path_cost(path_to_top_left, visitor.matrix)
min_cost_to_top_right = path_cost(path_to_top_right, visitor.matrix)
min_cost_to_bottom_left = path_cost(path_to_bottom_left, visitor.matrix)
min_cost_to_bottom_right = path_cost(path_to_bottom_right, visitor.matrix)

min_costs = {"TOP-LEFT" => min_cost_to_top_left, "TOP-RIGHT" => min_cost_to_top_right, 
  "BOTTOM-LEFT" => min_cost_to_bottom_left, "BOTTOM-RIGHT" => min_cost_to_bottom_right}

# Find min-paths to corner(s) with maximal cost compared to rest of min-paths
max_cost = min_costs.values.max
max_cost_corners = min_costs.select{|key, value| value == max_cost}

# Print out maximal of min-paths to each corner
max_cost_corners.each do |key, value|
  print key + " "
end
puts ''