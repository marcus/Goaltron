class AddGoaltronV1Tables < ActiveRecord::Migration
  def self.up
    create_table "entries", :force => true do |t|
      t.column "description", :text
      t.column "created_at", :datetime, :null => false
      t.column "deleted_at", :datetime
      t.column "goal_id", :integer
    end

    create_table "goals", :force => true do |t|
      t.column "description", :text
      t.column "created_at", :datetime, :null => false
      t.column "completed_at", :datetime
      t.column "deleted_at", :datetime
      t.column "user_id", :integer
      t.column "information", :text
      t.column "position", :integer
    end

    create_table "mission_versions", :force => true do |t|
      t.column "mission_id", :integer
      t.column "version", :integer
      t.column "description", :text
      t.column "user_id", :integer
      t.column "has_mission", :integer, :default => 0
      t.column "updated_at", :datetime
    end

    create_table "missions", :force => true do |t|
      t.column "description", :text
      t.column "user_id", :integer
      t.column "has_mission", :integer, :default => 0
      t.column "version", :integer
    end

    create_table "steps", :force => true do |t|
      t.column "position", :integer
      t.column "description", :text
      t.column "created_at", :datetime, :null => false
      t.column "completed_at", :datetime
      t.column "deleted_at", :datetime
      t.column "goal_id", :integer
    end
  end

  def self.down
    drop_table "entries"
    drop_table "goals"
    drop_table "mission_versions"
    drop_table "missions"
    drop_table "steps"
  end
end
