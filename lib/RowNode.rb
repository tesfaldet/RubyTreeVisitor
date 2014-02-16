# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work, adapted from 
#         the CarVisitor pattern by Attila Domokos 
#         <https://gist.github.com/adomokos/989193>

=begin
  A RowNode is a type of node of a Tree. It would contain a keyword such as 
  "R1,2,3" or "R1-3" (i.e. "R[integer sequence]" or "R[integer range]"), 
  values such as [1,2,3] (for R1,2,3) or [1,2,3,4,5,6] (for R1-6), and children.

  Children consists of an array of other TreeNodes.
  
=end
class RowNode < TreeNode
  include Visitable

  attr_reader :values
  attr_accessor :keyword
  attr_reader :children

  def initialize(values)
    @values = values
    @children = []
  end
end