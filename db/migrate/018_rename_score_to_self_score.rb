class RenameScoreToSelfScore < ActiveRecord::Migration
  def self.up
    rename_column "daily_day_entries", "score", "self_score"
  end

  def self.down
    rename_column "daily_day_entries", "self_score", "score"
  end
end
