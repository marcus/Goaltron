class MoreCommentsColumnsToContentsTable < ActiveRecord::Migration
  def self.up
    add_column "contents", "author_id", :integer
  end

  def self.down
    remove_column "contents", "author_id"
  end
end