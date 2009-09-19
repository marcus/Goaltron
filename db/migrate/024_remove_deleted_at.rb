class RemoveDeletedAt < ActiveRecord::Migration
  def self.up
    remove_column "goal_entries", "deleted_at"
    remove_column "goal_steps", "deleted_at"
    remove_column "goals", "deleted_at"
  end

  def self.down
    add_column "goal_entries", "deleted_at", :datetime
    add_column "goal_steps", "deleted_at", :datetime
    add_column "goals", "deleted_at", :datetime
  end
end
