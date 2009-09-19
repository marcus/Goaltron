class Goal < ActiveRecord::Base
  # Relationships
  belongs_to :user
  has_many :goal_steps, :dependent => :destroy, :order => :position
  has_many :goal_entries, :dependent => :destroy
  
  # Validations
  validates_presence_of :user_id, :description
  validates_uniqueness_of :description, :scope => :user_id

  # Behaviors
  acts_as_list :scope => :user_id
end