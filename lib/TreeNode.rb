# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work, adapted from 
#         the CarVisitor pattern by Attila Domokos 
#         <https://gist.github.com/adomokos/989193>

=begin
  A TreeNode is an interface.

=end
class TreeNode
  def accept(visitor)
    raise NotImpelementedError.new
  end
end