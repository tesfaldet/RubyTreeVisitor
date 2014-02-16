HOW TO INSTALL DEPENDENCIES
===========================

Dependencies used: 
  - 'algorithms' by Kanwei Li <https://github.com/kanwei/algorithms>

How to install:

1. If required, install 'bundler', if not then 
run 'gem install bundler'.

2. Run 'bundle install' from the 
project root directory.


HOW TO RUN
==========

1. Run 'rake' from the project root directory.

* Make sure the 'test' file is located in the project root directory and 
not in the lib directory.

** You can run ./main.rb as well but you will have to supply input of the form 
(([RC]k([,-]l)*)*+m;)* (where k,l,m are positive integers of any size).


NOTE
====

There is little to NO error checking. This is just for practicing with the 
syntax of Ruby.


MANIFEST
========

__root              __lib
  |                   |
  |__Gemfile          |__ColumnNode
  |                   | 
  |__Gemfile.lock     |__Graph
  |                   | 
  |__lib              |__IncrementNode
  |                   | 
  |__main.rb          |__ParseTree
  |                   | 
  |__Rakefile         |__RowNode
  |                   | 
  |__README.txt       |__Tree
  |                   | 
  |__test             |__TreeNode
                      | 
                      |__TreeNodePrintVisitor
                      | 
                      |__TreeNodeVisitor
                      | 
                      |__Visitable