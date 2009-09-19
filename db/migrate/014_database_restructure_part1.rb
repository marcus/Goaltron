class DatabaseRestructurePart1 < ActiveRecord::Migration
  #back up your database before your run this bad boy because it's destructive.
  def self.up
    #indicators becomes daily_goals and no longer contains the defaults.
    rename_table "indicators", "daily_goals"
    remove_column "daily_goals", "default_indicator"
    remove_column "daily_goals", "recommended"
    add_column "daily_goals", "active", :boolean, :default => 1
    add_column "daily_goals", "created_on", :date
    
    #personal_indicators goes bye bye
    drop_table "personal_indicators"
    
    #indicator_sets becomes daily_goal_status_sets (note the verbosity)
    rename_table "indicator_sets", "daily_goal_status_sets"
    rename_column "daily_goal_status_sets", "indicator_day", "set_date"
    
    #indicator_values becomes daily_goal_statuses
    rename_table "indicator_values", "daily_goal_statuses"
    rename_column "daily_goal_statuses", "indicator_id", "daily_goal_id"
    rename_column "daily_goal_statuses", "indicator_set_id", "daily_goal_status_set_id"
    rename_column "daily_goal_statuses", "value", "completed"
    change_column "daily_goal_statuses", "completed", :boolean, :default => 0
    
  end

  def self.down
    #daily_goals becomes indicators
    rename_table "daily_goals", "indicators"
    add_column "indicators", "default_indicator", :integer
    add_column "indicators", "recommended", :integer
    remove_column "indicators", "active"
    remove_column "indicators", "created_on"
    
    #bring back personal_indicators (sorry, all your data is lost forever)
    create_table "personal_indicators", :force => true do |t|
      t.column "user_id",      :integer
      t.column "indicator_id", :integer
      t.column "created_on",   :date
      t.column "active",       :integer, :limit => 2, :default => 1
    end
    
    #daily_goal_status_sets becomes indicator_sets
    rename_table "daily_goal_status_sets", "indicator_sets"
    rename_column "indicator_sets", "set_date", "indicator_day"
    
    #daily_goal_statuses becomes indicator_values
    rename_table "daily_goal_statuses", "indicator_values"
    rename_column "indicator_values", "daily_goal_id", "indicator_id"
    rename_column "indicator_values", "daily_goal_status_set_id", "indicator_set_id"
    rename_column "indicator_values", "completed", "value"
    change_column "indicator_values", "value", :string, :default => "0"
  end
end