class AssignedSection < ActiveRecord::Base
  belongs_to :article
  belongs_to :section
  acts_as_list :scope => :section_id
  validates_presence_of :article_id, :section_id
end
