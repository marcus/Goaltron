class DailyGoalEntry < ActiveRecord::Base
  # Relationships
  belongs_to :daily_goal
  belongs_to :daily_day_entry

  # Validations
  validates_presence_of :daily_day_entry_id, :daily_goal_id
  validates_uniqueness_of :daily_goal_id, :scope => :daily_day_entry_id
  validates_uniqueness_of :daily_day_entry_id, :scope => :daily_goal_id
end
