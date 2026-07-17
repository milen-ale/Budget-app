class BudgetCategory < ApplicationRecord
  # Keys of the curated icon set rendered by IconHelper.
  ICONS = %w[
    food transport housing entertainment health shopping
    utilities travel education savings pets other
  ].freeze

  belongs_to :author, class_name: 'User', inverse_of: :budget_categories
  has_many :expenses, dependent: :destroy, inverse_of: :budget_category

  validates :name, presence: true, length: { maximum: 60 },
                   uniqueness: { scope: :author_id, case_sensitive: false }
  validates :icon, presence: true, inclusion: { in: ICONS }

  scope :newest_first, -> { order(created_at: :desc) }
  scope :with_spending_totals, lambda {
    left_joins(:expenses)
      .select('budget_categories.*',
              'COALESCE(SUM(expenses.amount), 0) AS total_amount',
              'COUNT(expenses.id) AS expenses_count')
      .group(:id)
  }

  def total
    return self[:total_amount] if has_attribute?(:total_amount)

    expenses.sum(:amount)
  end

  def expense_count
    return self[:expenses_count] if has_attribute?(:expenses_count)

    expenses.count
  end
end
