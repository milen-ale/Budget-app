require 'rails_helper'

RSpec.describe 'BudgetCategories#index', type: :feature do
  before(:each) do
    user = User.create!(name: 'William Raga', email: 'raga@gmail.com', password: 'asdfghjkl')
    login_as(user, scope: :user)
    @budget_category1 = BudgetCategory.create!(author: user, name: 'Transportation', icon: 'https://plus.unsplash.com/premium_photo-1661573515969-f60143837505?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80')
    @budget_category2 = BudgetCategory.create!(author: user, name: 'Insurance', icon: 'https://images.unsplash.com/photo-1612831457048-9823ce1ebb6e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80')
    @budget_category3 = BudgetCategory.create!(author: user, name: 'Groceries', icon: 'https://images.unsplash.com/photo-1612831457048-9823ce1ebb6e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80')
    @transaction1 = Expense.create!(author: user, name: 'Fare', amount: 100.0, budget_categories: [@budget_category1])
    @transaction2 = Expense.create!(author: user, name: 'Groceries', amount: 100.0,
                                    budget_categories: [@budget_category1, @budget_category2])
    @transaction3 = Expense.create!(author: user, name: 'Fare', amount: 100.0, budget_categories: [@budget_category3])
    @budget_categories = BudgetCategory.all
    @user = User.first
    visit budget_category_expenses_path(@budget_category1)
  end

  it 'displays all categories names' do
    @budget_category1.expenses.each do |expense|
      expect(page).to have_content(expense.name)
    end
  end

  it 'displays all transaction amounts' do
    @budget_category1.expenses.each do |expense|
      expect(page).to have_content(expense.amount)
    end
  end

  it 'Redirects to add new transaction page' do
    click_link 'Add New Transaction'
    expect(current_path).to match new_budget_category_expense_path(@budget_category1)
  end
end
