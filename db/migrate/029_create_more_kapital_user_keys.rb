class CreateMoreKapitalUserKeys < ActiveRecord::Migration
  def self.up
    add_column :kapital_businesses, :user_id, :integer
    add_column :kapital_products, :user_id, :integer
  end

  def self.down
    remove_column :kapital_businesses, :user_id
    remove_column :kapital_products, :user_id
  end
end
