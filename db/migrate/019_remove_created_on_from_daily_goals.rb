class RemoveCreatedOnFromDailyGoals < ActiveRecord::Migration
  def self.up
    remove_column "daily_goals", "created_on"
  end

  def self.down
    add_column "daily_goals", "created_on", :date
  end
end
