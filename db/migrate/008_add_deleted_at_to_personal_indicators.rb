class AddDeletedAtToPersonalIndicators < ActiveRecord::Migration
  def self.up
    add_column "personal_indicators", "deleted_at", :datetime
  end

  def self.down
    remove_column "personal_indicators", "deleted_at"
  end
end
