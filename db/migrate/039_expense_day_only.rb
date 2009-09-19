class ExpenseDayOnly < ActiveRecord::Migration
  def self.up
    remove_column :kapital_expenses, :occurred_at
    add_column :kapital_expenses, :occurred_at, :date, :null => false
  end

  def self.down
    remove_column :kapital_expenses, :occurred_at
    add_column :kapital_expenses, :occurred_at, :datetime, :null => false
  end
end
