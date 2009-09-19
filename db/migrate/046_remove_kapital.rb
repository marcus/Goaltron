class RemoveKapital < ActiveRecord::Migration
  def self.up
    drop_table :kapital_business_types
    drop_table :kapital_businesses
    drop_table :kapital_expense_tags
    drop_table  :kapital_expenses
    drop_table  :kapital_product_types
    drop_table  :kapital_products
    drop_table  :kapital_tags
  end

  def self.down
  end
end
