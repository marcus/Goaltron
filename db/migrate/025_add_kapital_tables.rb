class AddKapitalTables < ActiveRecord::Migration
  def self.up
    # All important expense table
    create_table :kapital_expenses do |t|
      t.column :user_id, :integer
      t.column :kapital_business_id, :integer
      t.column :kapital_expense_type_id, :integer
      t.column :occurred_at, :datetime, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :amount, :decimal, :precision => 8, :scale => 2, :default => 0
      t.column :description, :text
    end

    # Basic types (no foreign keys)
    create_table :kapital_product_types do |t|
      t.column :name, :string
    end
    
    create_table :kapital_expense_types do |t|
      t.column :name, :string
    end
    
    create_table :kapital_business_types do |t|
      t.column :name, :string
    end

    create_table :kapital_tags do |t|
      t.column :name, :string
    end

    # Basic subtypes
    create_table :kapital_products do |t|
      t.column :kapital_product_type_id, :integer
      t.column :name, :string
    end

    create_table :kapital_businesses do |t|
      t.column :kapital_business_type_id, :integer
      t.column :name, :string
    end

    # Tables establishing many-to-many relationships
    create_table :kapital_expense_tags do |t|
      t.column :kapital_expense_id, :integer
      t.column :kapital_tag_id, :integer
    end
    
    create_table :kapital_expense_products do |t|
      t.column :kapital_expense_id, :integer
      t.column :kapital_product_id, :integer
    end
  end

  def self.down
    drop_table :kapital_expenses
    drop_table :kapital_product_types
    drop_table :kapital_expense_types
    drop_table :kapital_business_types
    drop_table :kapital_tags
    drop_table :kapital_products
    drop_table :kapital_businesses
    drop_table :kapital_expense_tags
    drop_table :kapital_expense_products
  end
end
