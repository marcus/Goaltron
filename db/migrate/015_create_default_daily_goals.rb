class CreateDefaultDailyGoals < ActiveRecord::Migration
  def self.up
    create_table :default_daily_goals do |t|
      t.column "name", :string
      t.column "description", :string
      t.column "recommended", :boolean
    end
  end

  def self.down
    drop_table :default_daily_goals
  end
end
