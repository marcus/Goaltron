class KapitalRethink < ActiveRecord::Migration
  def self.up
    remove_column :kapital_businesses, :user_id
    remove_column :kapital_expenses, :created_at
    remove_column :kapital_products, :user_id
  end

  def self.down
    add_column :kapital_businesses, :user_id, :integer
    add_column :kapital_expenses, :created_at, :datetime, :null => false
    add_column :kapital_products, :user_id, :integer
  end
end
