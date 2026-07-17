require 'rails_helper'

RSpec.describe 'Budget categories', type: :request do
  let(:user) { User.create!(name: 'Owner', email: 'owner@example.com', password: 'password123') }
  let(:other_user) { User.create!(name: 'Intruder', email: 'other@example.com', password: 'password123') }
  let(:category) { user.budget_categories.create!(name: 'Food', icon: 'food') }

  before { sign_in user }

  describe 'GET /budget_categories' do
    it "lists only the current user's categories" do
      category
      other_user.budget_categories.create!(name: 'Secret stash', icon: 'other')

      get budget_categories_path

      expect(response.body).to include('Food')
      expect(response.body).not_to include('Secret stash')
    end
  end

  describe 'POST /budget_categories' do
    it 'creates a category owned by the current user' do
      expect do
        post budget_categories_path, params: { budget_category: { name: 'Transport', icon: 'transport' } }
      end.to change(user.budget_categories, :count).by(1)

      expect(response).to redirect_to(budget_categories_path)
    end

    it 're-renders the form with 422 on invalid input' do
      post budget_categories_path, params: { budget_category: { name: '', icon: 'food' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /budget_categories/:id' do
    it 'updates own categories' do
      patch budget_category_path(category), params: { budget_category: { name: 'Groceries' } }

      expect(category.reload.name).to eq('Groceries')
      expect(response).to redirect_to(budget_categories_path)
    end
  end

  describe 'DELETE /budget_categories/:id' do
    it 'deletes the category together with its expenses' do
      category.expenses.create!(name: 'Lunch', amount: 9.5, author: user)

      expect { delete budget_category_path(category) }
        .to change(BudgetCategory, :count).by(-1)
        .and change(Expense, :count).by(-1)

      expect(response).to redirect_to(budget_categories_path)
    end
  end

  describe 'ownership enforcement (IDOR regression)' do
    let(:foreign_category) { other_user.budget_categories.create!(name: 'Foreign', icon: 'other') }

    it "cannot edit another user's category" do
      expect { get edit_budget_category_path(foreign_category) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end

    it "cannot update another user's category" do
      expect do
        patch budget_category_path(foreign_category), params: { budget_category: { name: 'Hacked' } }
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect(foreign_category.reload.name).to eq('Foreign')
    end

    it "cannot destroy another user's category" do
      foreign_category

      expect { delete budget_category_path(foreign_category) }
        .to raise_error(ActiveRecord::RecordNotFound)

      expect(BudgetCategory.exists?(foreign_category.id)).to be(true)
    end
  end
end
