class TightenBudgetDataConstraints < ActiveRecord::Migration[7.0]
  def up
    execute "UPDATE expenses SET amount = 0 WHERE amount IS NULL"
    execute "UPDATE expenses SET name = 'Untitled' WHERE name IS NULL"
    execute "UPDATE budget_categories SET name = 'Untitled' WHERE name IS NULL"
    execute "UPDATE budget_categories SET icon = 'other' WHERE icon IS NULL"

    change_column :expenses, :amount, :decimal, precision: 12, scale: 2
    change_column_null :expenses, :amount, false
    change_column_null :expenses, :name, false
    change_column_null :budget_categories, :name, false
    change_column_null :budget_categories, :icon, false

    add_check_constraint :expenses, 'amount >= 0', name: 'expenses_amount_nonnegative'
    add_index :budget_categories, %i[author_id name], unique: true
    add_index :expenses, %i[budget_category_id created_at]
  end

  def down
    remove_index :expenses, column: %i[budget_category_id created_at]
    remove_index :budget_categories, column: %i[author_id name]
    remove_check_constraint :expenses, name: 'expenses_amount_nonnegative'

    change_column_null :budget_categories, :icon, true
    change_column_null :budget_categories, :name, true
    change_column_null :expenses, :name, true
    change_column_null :expenses, :amount, true
    change_column :expenses, :amount, :float
  end
end
