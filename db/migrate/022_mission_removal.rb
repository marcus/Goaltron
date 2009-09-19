class MissionRemoval < ActiveRecord::Migration
  def self.up
    drop_table "missions"
    drop_table "mission_versions"
  end

  def self.down
    create_table "mission_versions", :force => true do |t|
      t.column "mission_id",  :integer
      t.column "version",     :integer
      t.column "description", :text
      t.column "user_id",     :integer
      t.column "has_mission", :integer,  :default => 0
      t.column "updated_at",  :datetime
    end

    create_table "missions", :force => true do |t|
      t.column "description", :text
      t.column "user_id",     :integer
      t.column "has_mission", :integer, :default => 0
      t.column "version",     :integer
    end

    add_index "missions", ["user_id"], :name => "fk_missions_user"
  end
end
