require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { User.create!(name: 'Alia', email: 'alia@example.com', password: 'password123') }
  let(:category) { user.budget_categories.create!(name: 'Food', icon: 'food') }

  def build_expense(attrs = {})
    category.expenses.new({ name: 'Lunch', amount: 9.99, author: user }.merge(attrs))
  end

  it 'is valid with a name, positive amount, author and category' do
    expect(build_expense).to be_valid
  end

  it 'requires a name' do
    expect(build_expense(name: '')).not_to be_valid
  end

  it 'rejects a zero amount' do
    expect(build_expense(amount: 0)).not_to be_valid
  end

  it 'rejects negative amounts' do
    expect(build_expense(amount: -5)).not_to be_valid
  end

  it 'rejects a category owned by another user' do
    stranger = User.create!(name: 'Ben', email: 'ben@example.com', password: 'password123')
    expense = build_expense(author: stranger)

    expect(expense).not_to be_valid
    expect(expense.errors[:budget_category]).to be_present
  end

  it 'stores money exactly as decimal' do
    expense = build_expense(amount: 10.10)
    expense.save!
    expect(expense.reload.amount).to eq(BigDecimal('10.10'))
  end
end
