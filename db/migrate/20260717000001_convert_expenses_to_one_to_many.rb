class ConvertExpensesToOneToMany < ActiveRecord::Migration[7.0]
  def up
    add_reference :expenses, :budget_category, foreign_key: true

    execute <<~SQL.squish
      UPDATE expenses
      SET budget_category_id = (
        SELECT budget_category_id
        FROM budget_category_expenses
        WHERE budget_category_expenses.expense_id = expenses.id
        ORDER BY budget_category_expenses.id
        LIMIT 1
      )
    SQL

    execute 'DELETE FROM expenses WHERE budget_category_id IS NULL'
    change_column_null :expenses, :budget_category_id, false

    drop_table :budget_category_expenses
  end

  def down
    create_table :budget_category_expenses do |t|
      t.references :budget_category, null: false, foreign_key: true
      t.references :expense, null: false, foreign_key: true
      t.timestamps
    end

    execute <<~SQL.squish
      INSERT INTO budget_category_expenses (budget_category_id, expense_id, created_at, updated_at)
      SELECT budget_category_id, id, NOW(), NOW() FROM expenses
    SQL

    remove_reference :expenses, :budget_category
  end
end
