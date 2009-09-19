class AddTypeToContents < ActiveRecord::Migration
  def self.up
    add_column "contents", "type", :string
    add_column "contents", "article_id", :integer
  end

  def self.down
    remove_column "contents", "type"
    remove_column "contents", "article_id"
  end
end
