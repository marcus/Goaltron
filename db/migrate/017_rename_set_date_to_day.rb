class RenameSetDateToDay < ActiveRecord::Migration
  def self.up
    rename_column "daily_day_entries", "set_date", "day"
  end

  def self.down
    rename_column "daily_day_entries", "day", "set_date"
  end
end
