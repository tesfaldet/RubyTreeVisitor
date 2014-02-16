# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work.

=begin
  A ParseTree takes in input of the form (([RC]k([,-]l)*)*+m;)* 
  (where k,l,m are positive integers of any size) and is able 
  to produce a corresponding tree consisting of TreeNodes 
  (i.e. IncrementNode, RowNodes, ColumnNodes, Trees, etc.)

=end
class ParseTree
  def initialize(string)
    @string = string
  end

  # Create an array of TreeNodes from input string.
  #
  #   @children = ParseTree.new("C1,8R1+4;R3-4C2C7+4;").parse
  def parse
    arr = [] # will hold array of IncrementNodes

    # patterns for regex (these were hard to get right...)
    digit = '\d'
    number = digit + '+'
    range = number + '\-' + number
    keyword = '[RC](?:(?:' + range + ')|(?:' + number + '(?:\,' + number + ')*))'
    adder = '\+' + number
    subtree = '(?:' + keyword + ')+' + adder + ";"

    # parse user input into subtrees (IncrementNodes)
    match_array(@string, subtree).each do |e|

      # insert IncrementNode for each subtree
      increment_value = match_array(e, adder)[0]
      arr << IncrementNode.new(increment_value) # put IncrementNode (w. increment val) in parsed result array
      arr.last.keyword = "I" + increment_value # putting in keyword into IncrementNode (e.g. keyword being like I+4)
      
      last_elem = ''

      # parse each subtree into RowNodes and ColumnNodes
      match_array(e, keyword).each do |el| # look for a keyword like C2-4 or R1,2

        values = [] # will contain values for a node
        
        if el.include? "," # encounter sequence of nums like R1,2,3, put 1,2,3 in a RowNode
          values = match_array(el, number)
        elsif el.include? "-" # encounter a range like C1-5, put 1,2,3,4,5 in a ColumnNode
          begin_num = match_array(el, number)[0]
          end_num = match_array(el, number)[1]
          for index in begin_num..end_num
            values << index 
          end
        else
          values << match_array(el, number)[0] # put just the single number, e.g. R1, put 1 in RowNode
        end
        
        insert_into_fourth_layer = false # if true, force node insertion into fourth layer
        
        # when received row type keyword (e.g. R1)
        if el[0] == 'R' && last_elem != 'C' # put as child of last IncrementNode only if last node was not ColumnNode
          arr.last.children << RowNode.new(values) # put in children array of last IncrementNode
          arr.last.children.last.keyword = el # put in keyword into RowNode (e.g. keyword being R5-6 or similar)
        elsif el[0] == 'R' # put as child of last ColumnNode
          arr.last.children.last.children << RowNode.new(values)
          arr.last.children.last.children.last.keyword = el # put in keyword
          last_elem = 'C'
          insert_into_fourth_layer = true
        end
        
        # when received column type keyword (e.g. C1)
        if el[0] == 'C' && last_elem != 'R'
          arr.last.children << ColumnNode.new(values)
          arr.last.children.last.keyword = el
        elsif el[0] == 'C'
          arr.last.children.last.children << ColumnNode.new(values)
          arr.last.children.last.children.last.keyword = el
          last_elem = 'R'
          insert_into_fourth_layer = true
        end
        
        # insert node into third layer if not true, otherwise insert into fourth
        if !insert_into_fourth_layer
          last_elem = el[0] # last_elem would be an IncrementNode in this case
        end

      end

    end

    return arr
  end

  # Create an array of matching character sequences.
  #
  #   arr = match_array("C1,8R1+4;", '\d')
  #   arr #=> ["1", "8", "1", "4"]
  def match_array(string, match_string)
    arr = []
    string.scan(Regexp.new(match_string)) do |element|
      arr << element
    end
    return arr
  end
end