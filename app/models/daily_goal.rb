class DailyGoal < ActiveRecord::Base
  # Relationships
  belongs_to :user
  has_many :daily_goal_entries, :dependent => :destroy

  # Validations
  validates_presence_of :name, :description, :user_id
  validates_uniqueness_of :name, :scope => :user_id

  class << self
    def active_goals(user_id)
      find(:all, :conditions => {:user_id => user_id, :active => true})
    end
    
    def inactive_goals(user_id)
      find(:all, :conditions => {:user_id => user_id, :active => false})
    end
  end
end
