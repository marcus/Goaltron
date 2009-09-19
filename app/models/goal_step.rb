class GoalStep < ActiveRecord::Base
  # Relationships
  belongs_to :goal

  # Validations
  validates_uniqueness_of :description, :scope => :goal_id
  
  # Behaviors
  acts_as_list :scope => :goal_id
end
