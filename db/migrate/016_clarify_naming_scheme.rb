class ClarifyNamingScheme < ActiveRecord::Migration
  def self.up
    rename_table "default_daily_goals", "daily_default_goals"
    change_column "daily_default_goals", "recommended", :boolean, :default => true
    rename_table "daily_goal_statuses", "daily_goal_entries"
    rename_column "daily_goal_entries", "daily_goal_status_set_id",  "daily_day_entry_id"
    rename_table "daily_goal_status_sets", "daily_day_entries"
    rename_column "daily_day_entries", "description", "synopsis"
  end

  def self.down
    rename_table "daily_default_goals", "default_daily_goals"
    change_column "default_daily_goals", "recommended", :boolean
    rename_table "daily_goal_entries", "daily_goal_statuses"
    rename_column "daily_goal_statuses", "daily_day_entry_id", "daily_goal_status_set_id"
    rename_table "daily_day_entries", "daily_goal_status_sets"
    rename_column "daily_goal_status_sets", "synopsis", "description"
  end
end
