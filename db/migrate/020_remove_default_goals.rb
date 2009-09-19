class RemoveDefaultGoals < ActiveRecord::Migration
  def self.up
    drop_table "daily_default_goals"
  end

  def self.down
    create_table "daily_default_goals" do |t|
      t.column "name",        :string
      t.column "description", :string
      t.column "recommended", :boolean, :default => true
    end
  end
end
