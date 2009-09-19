class Comment < Content
  validates_presence_of :user_id, :body
  
  belongs_to :article
  
  acts_as_nested_set
  
end
