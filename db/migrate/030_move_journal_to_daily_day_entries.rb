class MoveJournalToDailyDayEntries < ActiveRecord::Migration
  def self.up
    rename_column "daily_day_entries", "synopsis", "good"
    add_column "daily_day_entries", "bad", :text
  end

  def self.down
    rename_column "daily_day_entries", "good", "synopsis"
    remove_column "daily_day_entries", "bad"
  end
end
