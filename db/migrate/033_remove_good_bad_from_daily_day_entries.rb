class RemoveGoodBadFromDailyDayEntries < ActiveRecord::Migration
  def self.up
    remove_column "daily_day_entries", "good"
    remove_column "daily_day_entries", "bad"
  end

  def self.down
    add_column "daily_day_entries", "good", :text
    add_column "daily_day_entries", "bad", :text
  end
end
