class AddRecommendedToIndicators < ActiveRecord::Migration
  def self.up
    add_column "indicators", "recommended", :integer
  end

  def self.down
    remove_column "indicators", "recommended"
  end
end
