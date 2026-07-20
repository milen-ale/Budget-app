class Expense < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :expenses
  belongs_to :budget_category, inverse_of: :expenses

  validates :name, presence: true, length: { maximum: 60 }
  validates :amount, presence: true,
                     numericality: { greater_than: 0, less_than: 1_000_000_000 }
  validate :budget_category_belongs_to_author

  scope :newest_first, -> { order(created_at: :desc) }

  private

  # Scoping in controllers already prevents cross-user writes; this guards
  # console scripts and future endpoints against silently mixing owners.
  def budget_category_belongs_to_author
    return if budget_category.nil? || author_id.nil?
    return if budget_category.author_id == author_id

    errors.add(:budget_category, 'must be one of your own categories')
  end
end
