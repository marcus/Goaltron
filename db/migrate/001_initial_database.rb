class InitialDatabase < ActiveRecord::Migration
  def self.up

    create_table :indicators_users do |t|
      t.column :user_id, :integer
      t.column :indicator_id, :integer
    end
    
    create_table :indicators do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :default_indicator, :integer
    end
    
    create_table :indicator_values do |t|
      t.column :indicator_id, :integer
      t.column :user_id, :integer
      t.column :value, :string, :default => "0"
      t.column :created_at, :datetime
      t.column :modified_at, :datetime
    end
  end

  def self.down
    drop_table "user_indicators"
    drop_table "indicators"
    drop_table "indicator_values"
  end
end
