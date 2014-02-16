# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work, adapted from 
#         the CarVisitor pattern by Attila Domokos 
#         <https://gist.github.com/adomokos/989193>

=begin
  A Tree is a type of node of a Tree (a node can be a tree). 
  It would contain a keyword "T", and children.

  Children consists of an array of other TreeNodes.
  
=end
class Tree < TreeNode
  include Visitable

  attr_reader :children
  attr_accessor :keyword

  def initialize(string)
    @children = ParseTree.new(string).parse
    @keyword = "T"
  end
end