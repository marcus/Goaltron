class AddNestedCommentsColumnsToArticles < ActiveRecord::Migration
  def self.up
    add_column "contents", "parent_is", :integer
    # Not using "left" and "right" since they are reserved
    add_column "contents", "lft", :integer
    add_column "contents", "rgt", :integer
  end

  def self.down
    remove_column "contents", "parent_is"
    remove_column "contents", "lft"
    remove_column "contents", "rgt"
  end
end
