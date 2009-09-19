class JournalEntry < ActiveRecord::Base
  belongs_to :user
  cattr_reader :per_page
  @@per_page = 40
end