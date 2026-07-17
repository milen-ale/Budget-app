require 'rails_helper'

RSpec.describe 'Expenses', type: :request do
  let(:user) { User.create!(name: 'Owner', email: 'owner@example.com', password: 'password123') }
  let(:other_user) { User.create!(name: 'Intruder', email: 'other@example.com', password: 'password123') }
  let(:category) { user.budget_categories.create!(name: 'Food', icon: 'food') }
  let(:expense) { category.expenses.create!(name: 'Lunch', amount: 9.99, author: user) }

  before { sign_in user }

  describe 'GET /budget_categories/:id/expenses' do
    it 'lists the expenses of the category with their total' do
      expense
      category.expenses.create!(name: 'Dinner', amount: 20.01, author: user)

      get budget_category_expenses_path(category)

      expect(response.body).to include('Lunch', 'Dinner')
      expect(response.body).to include('$30.00')
    end
  end

  describe 'POST /budget_categories/:id/expenses' do
    it 'creates an expense authored by the current user' do
      expect do
        post budget_category_expenses_path(category), params: { expense: { name: 'Coffee', amount: 3.5 } }
      end.to change(category.expenses, :count).by(1)

      expect(category.expenses.last.author).to eq(user)
    end

    it 'ignores attempts to forge the author through params' do
      post budget_category_expenses_path(category),
           params: { expense: { name: 'Forged', amount: 5, author_id: other_user.id } }

      expect(category.expenses.find_by(name: 'Forged').author).to eq(user)
    end

    it 're-renders the form with 422 on invalid input' do
      post budget_category_expenses_path(category), params: { expense: { name: '', amount: -1 } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /budget_categories/:id/expenses/:id' do
    it 'updates own expenses' do
      patch budget_category_expense_path(category, expense), params: { expense: { amount: 12.34 } }

      expect(expense.reload.amount).to eq(BigDecimal('12.34'))
    end
  end

  describe 'DELETE /budget_categories/:id/expenses/:id' do
    it 'deletes the expense and redirects to the category' do
      expense

      expect { delete budget_category_expense_path(category, expense) }
        .to change(Expense, :count).by(-1)

      expect(response).to redirect_to(budget_category_expenses_path(category))
    end
  end

  describe 'ownership enforcement (IDOR regression)' do
    let(:foreign_category) { other_user.budget_categories.create!(name: 'Foreign', icon: 'other') }
    let(:foreign_expense) { foreign_category.expenses.create!(name: 'Private', amount: 50, author: other_user) }

    it "cannot list another user's expenses" do
      expect { get budget_category_expenses_path(foreign_category) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end

    it "cannot delete another user's expense" do
      foreign_expense

      expect { delete budget_category_expense_path(foreign_category, foreign_expense) }
        .to raise_error(ActiveRecord::RecordNotFound)

      expect(Expense.exists?(foreign_expense.id)).to be(true)
    end
  end
end
