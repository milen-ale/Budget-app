require 'rails_helper'

RSpec.describe BudgetCategory, type: :model do
  let(:user) { User.create!(name: 'Alia', email: 'alia@example.com', password: 'password123') }

  it 'is valid with a name, a curated icon and an author' do
    expect(user.budget_categories.new(name: 'Food', icon: 'food')).to be_valid
  end

  it 'requires a name' do
    expect(user.budget_categories.new(name: '', icon: 'food')).not_to be_valid
  end

  it 'rejects icons outside the curated set' do
    expect(user.budget_categories.new(name: 'Food', icon: 'rocket')).not_to be_valid
  end

  it 'rejects duplicate names for the same user, ignoring case' do
    user.budget_categories.create!(name: 'Food', icon: 'food')
    expect(user.budget_categories.new(name: 'food', icon: 'other')).not_to be_valid
  end

  it 'allows the same name for different users' do
    user.budget_categories.create!(name: 'Food', icon: 'food')
    other = User.create!(name: 'Ben', email: 'ben@example.com', password: 'password123')
    expect(other.budget_categories.new(name: 'Food', icon: 'food')).to be_valid
  end

  it 'keeps the model icon set in sync with the helper icon set' do
    expect(IconHelper::CATEGORY_ICONS.keys).to match_array(described_class::ICONS)
  end

  describe 'totals' do
    let(:category) { user.budget_categories.create!(name: 'Food', icon: 'food') }

    before do
      category.expenses.create!(name: 'Lunch', amount: 12.25, author: user)
      category.expenses.create!(name: 'Dinner', amount: 30, author: user)
    end

    it 'sums its expenses' do
      expect(category.total).to eq(42.25)
    end

    it 'exposes aggregated totals through with_spending_totals in one query' do
      aggregated = user.budget_categories.with_spending_totals.find(category.id)
      expect(aggregated.total).to eq(42.25)
      expect(aggregated.expense_count).to eq(2)
    end
  end
end
