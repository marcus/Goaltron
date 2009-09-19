class RenameIndicatorsUsersToPersonalIndicators < ActiveRecord::Migration
  def self.up
    rename_table "indicators_users", "personal_indicators"
  end

  def self.down
    rename_table "personal_indicators", "indicators_users"
  end
end
