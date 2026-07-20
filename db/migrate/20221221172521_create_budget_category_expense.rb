class CreateBudgetCategoryExpense < ActiveRecord::Migration[7.0]
  def change
    create_table :budget_category_expenses do |t|
      t.references :budget_category, null:false, foreign_key: true
      t.references :expense, null:false, foreign_key: true
      t.timestamps
    end
  end
end
