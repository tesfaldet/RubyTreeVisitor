# Name:   Matthew Tesfaldet
# Course: CPS506, Winter 2014, Assignment #1
# Due:    2014.02.17 23:59
# Credit: This is entirely my own work, adapted from 
#         the CarVisitor pattern by Attila Domokos 
#         <https://gist.github.com/adomokos/989193>

=begin
  A TreeNodeVisitor is a visitor intended to "visit" each 
  node of a Tree, inspecting each node and doing some sort 
  of action with it.
  
=end
class TreeNodeVisitor
  attr_reader :matrix
  attr_reader :rows
  attr_reader :columns
  attr_reader :transformation_array
  attr_reader :number_of_rows
  attr_reader :number_of_columns

  def initialize()
    @matrix = []
    @rows_affected = []
    @columns_affected = []
    @transformation_array = []
    @number_of_rows = 0
    @number_of_columns = 0
  end

  # Visit each IncrementNode of a Tree, keeping track of rows and columns  
  # that are going to be affected by a transformation.
  def visit(subject)
    # visit each IncrementNode
    if (subject.class.to_s == "IncrementNode")
      adder_value = subject.increment_value.to_i

      # iterate through IncrementNode's immediate children
      subject.children.each do |node|
        rows = []
        columns = []

        # immediate child node's area of effect 
        # (e.g. C1 would have an effect on [[], [1]] -> [[rows], [columns]] )
        if node.class.to_s == "RowNode"
          rows = node.values
        elsif node.class.to_s == "ColumnNode" 
          columns = node.values
        end

        # iterate through children of immediate child node (of IncrementNode) 
        # and combine areas of effect for each child with immediate child (of IncrementNode) 
        node.children.each do |child|
          if child.class.to_s == "RowNode"
            rows << child.values
            rows = rows.flatten # flatten to avoid case like [[[rows]], [columns]]
          elsif child.class.to_s == "ColumnNode" 
            columns << child.values
            columns = columns.flatten
          end
        end

        # keeping track of rows and columns that are going to be affected
        @rows_affected << rows
        @rows_affected = @rows_affected.flatten
        @columns_affected << columns
        @columns_affected = @columns_affected.flatten

        # add matrix transformation to transformation array 
        @transformation_array << [adder_value, [rows, columns]]
      end
    end
  end

  # Create a 2D array where both number of rows and columns must be rounded up 
  # from the maximum referenced in the trees to be an odd number.
  #
  # Apply function after using 'visit':
  #   t = Tree.new("C1,8R1+4;")
  #   t.accept(TreeNodeVisitor.new)    <- implicitly calls 'visit'
  #   t.create_matrix #=> [[0,0,0,0,0,0,0,0,0]]
  def create_matrix
    rows_affected = []
    columns_affected = []

    # converting from string to int
    @rows_affected.each do |row|
      rows_affected << row.to_i
    end
    @columns_affected.each do |column|
      columns_affected << column.to_i
    end

    max_rows = rows_affected.max
    max_columns = columns_affected.max

    # round up to odd num
    if max_rows % 2 == 0
      max_rows = max_rows + 1
    end
    if max_columns % 2 == 0
      max_columns = max_columns + 1
    end

    @matrix = Array.new(max_rows)
    for index in 0...max_rows
      @matrix[index] = Array.new(max_columns)
    end

    # initialize matrix with 0s
    for i in 0...max_rows
      for j in 0...max_columns
        @matrix[i][j] = 0
      end
    end

    @number_of_rows = @matrix.size
    @number_of_columns = @matrix[0].size
  end

  # Apply transformations to matrix. So for example, "C1,8R1+4;" would apply 
  # the transformation "+2" to the intersection of columns 1,8 and row 1.
  #
  # Apply function after using 'visit' and 'create_matrix':
  #   t = Tree.new("C1,8R1+4;")
  #   t.accept(TreeNodeVisitor.new)    <- implicitly calls 'visit'
  #   t.create_matrix     #=> [[0,0,0,0,0,0,0,0,0]]
  #   t.transform_matrix  #=> [[4,0,0,0,0,0,0,4,0]]
  def transform_matrix
    @transformation_array.each do |transformation|
      adder_value = transformation[0]
      rows_to_transform = transformation[1][0]
      columns_to_transform = transformation[1][1]

      # only given rows or columns to transform, but not both.
      # then assume transformation of all columns or rows
      # e.g. R5+2; would mean that row 5 was specified to be 
      # transformed. so assume all columns get transformed as well
      if rows_to_transform.empty?
        for index in 1..@number_of_rows
          rows_to_transform << index
        end
      elsif columns_to_transform.empty?
        for index in 1..@number_of_columns
          columns_to_transform << index
        end
      end

      # cartesian product between rows and columns to be transformed
      areas = rows_to_transform.product(columns_to_transform)

      # apply transformation
      areas.each do |tuple|
        row = tuple[0].to_i - 1
        column = tuple[1].to_i - 1
        @matrix[row][column] = @matrix[row][column] + adder_value
      end

    end
  end

  # Prints out the matrix.
  #
  # Apply function after using 'visit' and 'create_matrix':
  #   t = Tree.new("C1,8R1+4;R1-2C2C1+4;")
  #   t.accept(TreeNodeVisitor.new)    <- implicitly calls 'visit'
  #   t.create_matrix     #=> [[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
  #   t.transform_matrix  #=> [[8,4,0,0,0,0,0,4,0],[4,4,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
  #   t.print_matrix      #=> 840000040
  #                           440000000
  #                           000000000
  def print_matrix
    for i in 0...@number_of_rows
      for j in 0...@number_of_columns
        print @matrix[i][j]
      end
      puts ''
    end
  end
end