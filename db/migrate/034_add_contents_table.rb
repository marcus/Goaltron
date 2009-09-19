class AddContentsTable < ActiveRecord::Migration
  def self.up
    create_table "contents" do |t|
        t.column "user_id", :integer
        
        t.column "title", :string
        t.column "body", :text
        t.column "excerpt", :text
        
        t.column "permalink", :string
        
        t.column "public", :boolean
        t.column "approved", :boolean
        t.column "comment_status", :boolean
        
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
        t.column "published_at", :datetime
    end
    
    create_table "sections" do |t|
        t.column "name", :string
    end
  end

  def self.down
    drop_table "contents"
    drop_table "sections"
  end
end
