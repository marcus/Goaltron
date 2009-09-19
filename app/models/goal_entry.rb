class GoalEntry < ActiveRecord::Base
  # Relationships
  belongs_to :goal

  # Validations
  validates_presence_of :goal_id, :description
  validates_uniqueness_of :description, :scope => :goal_id
end