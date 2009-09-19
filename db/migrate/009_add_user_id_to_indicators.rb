class AddUserIdToIndicators < ActiveRecord::Migration
  def self.up
    add_column "indicators", "user_id", :integer
  end

  def self.down
    remove_column "indicators", "user_id"
  end
end
