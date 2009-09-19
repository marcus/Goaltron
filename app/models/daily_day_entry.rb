class DailyDayEntry < ActiveRecord::Base
  # Relationships
  belongs_to :user
  has_many :daily_goal_entries, :order => "daily_goal_id DESC", :dependent => :destroy
  
  # Validations
  validates_presence_of :user_id, :day
  validates_uniqueness_of :day, :scope => :user_id

  # Return day's active goal entries (creating if needed)
  def active_goal_entries
    active_goals = self.user.daily_goals.find(:all, :conditions => {:active => true})
    active_goal_entries = Array.new;
    active_goals.map { |active_goal|
      # Try to find existing one
      active_goal_entry = DailyGoalEntry.find(:first, :conditions => { 
                                                  :daily_day_entry_id => self.id,
                                                  :daily_goal_id => active_goal.id })
      
      # If not found, create a new one
      if active_goal_entry == nil
        active_goal_entry = DailyGoalEntry.new
        active_goal_entry.daily_goal_id = active_goal.id
        active_goal_entry.daily_day_entry_id = self.id
        active_goal_entry.completed = false;
        active_goal_entry.save
      end

      # Return as this entry in our mapping
      active_goal_entry
    }
  end
  
  # Get our current (calculated from goals) score
  def calculated_score
    active_goal_entries.delete_if{|goal|not goal.completed}.length;
  end
end
