class AddDescriptionAndScoreToIndicatorSets < ActiveRecord::Migration
  def self.up
    add_column "indicator_sets", "score", :integer, :default => 0
    add_column "indicator_sets", "description", :text
  end

  def self.down
    remove_column "indicator_sets", "score"
    remove_column "indicator_sets", "description"
  end
end
