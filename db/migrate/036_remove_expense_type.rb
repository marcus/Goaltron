class RemoveExpenseType < ActiveRecord::Migration
  def self.up
    drop_table :kapital_expense_types
    remove_column :kapital_expenses, :kapital_expense_type_id
  end

  def self.down
    create_table :kapital_expense_types do |t|
      t.column :name, :string
      t.column :user_id, :integer
    end
    add_column :kapital_expenses, :kapital_expense_type_id, :integer
  end
end
