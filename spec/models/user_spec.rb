require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new(name: 'Alia', email: 'alia@example.com', password: 'password123') }

  it 'is valid with a name, email and password' do
    expect(user).to be_valid
  end

  it 'requires a name' do
    user.name = nil
    expect(user).not_to be_valid
  end

  it 'sums spending across all expenses' do
    user.save!
    category = user.budget_categories.create!(name: 'Food', icon: 'food')
    category.expenses.create!(name: 'Lunch', amount: 10.5, author: user)
    category.expenses.create!(name: 'Dinner', amount: 20, author: user)

    expect(user.total_spent).to eq(30.5)
  end

  it 'destroys its categories and expenses when destroyed' do
    user.save!
    category = user.budget_categories.create!(name: 'Food', icon: 'food')
    category.expenses.create!(name: 'Lunch', amount: 10, author: user)

    expect { user.destroy }
      .to change(Expense, :count).by(-1)
      .and change(BudgetCategory, :count).by(-1)
  end
end
