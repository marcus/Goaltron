class RemoveDeletedAtFromPersonalIndicators < ActiveRecord::Migration
  def self.up
    remove_column "personal_indicators", "deleted_at"
  end

  def self.down
    add_column "personal_indicators", "deleted_at", :datetime
  end
end
