class RenameParentColumnInContent < ActiveRecord::Migration
  def self.up
    rename_column "contents", "parent_is", "parent_id"
  end

  def self.down
    rename_column "contents", "parent_id", "parent_is"
  end
end
