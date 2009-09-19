class AddActiveToPersonalIndicators < ActiveRecord::Migration
  def self.up
    add_column "personal_indicators", "active", :integer, :limit => 2, :default => 1
  end

  def self.down
    remove_column "personal_indicators", "active"
  end
end
