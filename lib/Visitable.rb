# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work, adapted from 
#         the CarVisitor pattern by Attila Domokos 
#         <https://gist.github.com/adomokos/989193>

=begin
  Visitable is a module that implements the 'accept' method 
  for the visitor pattern. It allows for an object that contains 
  an array of objects (both of which includes Visitable) to be 
  able to be visited by a visitor (such as TreeNodeVisitor). 
  
=end
module Visitable
  def accept(visitor)
    visitor.visit(self)
    @children.each do |element|
      element.accept(visitor)
    end
  end
end