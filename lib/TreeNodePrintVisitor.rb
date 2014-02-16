# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work, adapted from 
#         the CarVisitor pattern by Attila Domokos 
#         <https://gist.github.com/adomokos/989193>

=begin
  A TreeNodePrintVisitor is a visitor intended to "visit" each 
  node of a Tree, printing out the keyword of each TreeNode.
  
=end
class TreeNodePrintVisitor
  # Visit a TreeNode.
  #
  #   t = Tree.new("C1,8R1+4;")
  #   t.accept(TreeNodePrintVisitor.new) #=> T
  #                                          I+4
  #                                          C1,8
  #                                          R1
  def visit(subject)
    if (subject.class.to_s == "IncrementNode")
      puts subject.keyword
    elsif (subject.class.to_s == "RowNode")
      puts subject.keyword
    elsif (subject.class.to_s == "ColumnNode")
      puts subject.keyword
    elsif (subject.class.to_s == "Tree")
      puts subject.keyword
    end
  end
end