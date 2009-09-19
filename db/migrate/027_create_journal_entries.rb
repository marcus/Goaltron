class CreateJournalEntries < ActiveRecord::Migration
  def self.up
    create_table :journal_entries do |t|
      t.column "user_id", :integer
      t.column "entry_date", :date
      t.column "good", :text
      t.column "bad", :text
      t.column "public", :boolean, :default => false
      t.column "draft", :boolean, :default => false
    end
  end

  def self.down
    drop_table :journal_entries
  end
end