class CreateIndicatorSets < ActiveRecord::Migration
  def self.up
    remove_column "indicator_values", "modified_at"
    remove_column "indicator_values", "created_at"
    remove_column "indicator_values", "user_id"
    add_column "indicator_values", "indicator_set_id", :integer
    
    create_table "indicator_sets" do |t|
      t.column "user_id", :integer
      t.column "indicator_day", :date
    end
  end

  def self.down
    add_column "indicator_values", "modified_at", :datetime
    add_column "indicator_values", "created_at", :datetime
    add_column "indicator_values", "user_id", :integer
    remove_column "indicator_values", "indicator_set_id"
    
    drop_table "indicator_sets"
  end
end
