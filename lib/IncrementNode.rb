# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work, adapted from 
#         the CarVisitor pattern by Attila Domokos 
#         <https://gist.github.com/adomokos/989193>

=begin
  An IncrementNode is a type of node of a Tree. It would contain a keyword such as 
  "I+3" (i.e. "I+[integer]") an increment value such as "+3", and children.

  Children consists of an array of other TreeNodes.
  
=end
class IncrementNode < TreeNode
  include Visitable

  attr_reader :increment_value
  attr_accessor :keyword
  attr_reader :children

  def initialize(increment_value)
    @increment_value = increment_value
    @children = []
  end
end