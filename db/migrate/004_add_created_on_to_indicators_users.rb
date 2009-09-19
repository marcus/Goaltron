class AddCreatedOnToIndicatorsUsers < ActiveRecord::Migration
  def self.up
    add_column "indicators_users", "created_on", :date
  end

  def self.down
    remove_column "indicators_users", "created_on"
  end
end