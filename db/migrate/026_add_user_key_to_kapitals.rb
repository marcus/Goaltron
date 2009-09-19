class AddUserKeyToKapitals < ActiveRecord::Migration
  def self.up
    add_column :kapital_product_types, :user_id, :integer
    add_column :kapital_expense_types, :user_id, :integer
    add_column :kapital_business_types, :user_id, :integer
    add_column :kapital_tags, :user_id, :integer
  end

  def self.down
    remove_column :kapital_product_types, :user_id
    remove_column :kapital_expense_types, :user_id
    remove_column :kapital_business_types, :user_id
    remove_column :kapital_tags, :user_id
  end
end
