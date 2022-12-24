class BudgetCategoryExpense < ApplicationRecord
  belongs_to :budget_category
  belongs_to :expense
end
