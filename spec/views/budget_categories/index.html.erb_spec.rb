require 'rails_helper'

RSpec.describe 'BudgetCategories#index', type: :feature do
  before(:each) do
    user = User.create!(name: 'josh', email: 'milnenalebe2@gmail.com', password: '123456')
    login_as(user, scope: :user)
    @budget_categories = BudgetCategory.all
    @user = User.first
    visit budget_categories_path
  end

  it 'Redirects to add new category page' do
    click_link 'Add New Category'
    expect(current_path).to match new_budget_category_path
  end
end
