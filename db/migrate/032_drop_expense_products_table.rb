class DropExpenseProductsTable < ActiveRecord::Migration
  def self.up
    drop_table "kapital_expense_products"
    add_column "kapital_expenses", "kapital_product_id", :integer
  end

  def self.down
    create_table "kapital_expense_products" do |t|
      t.column "kapital_expense_id", :integer
      t.column "kapital_product_id", :integer
    end
    remove_column "kapital_expenses", "kapital_product_id"
  end
end
