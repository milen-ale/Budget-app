class Expense < ApplicationRecord
  belongs_to :user
  has_many :budget_categories
end
