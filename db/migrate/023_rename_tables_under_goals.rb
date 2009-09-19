class RenameTablesUnderGoals < ActiveRecord::Migration
  def self.up
    # Clarify names to be part of "goals".
    rename_table "entries", "goal_entries"
    rename_table "steps", "goal_steps"
  end

  def self.down
    rename_table "goal_entries", "entries"
    rename_table "goal_steps", "steps"
  end
end
