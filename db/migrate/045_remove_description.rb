class RemoveDescription < ActiveRecord::Migration
  def self.up
    remove_column :kapital_expenses, :description
  end

  def self.down
    add_column :kapital_expenses, :description, :text
  end
end
