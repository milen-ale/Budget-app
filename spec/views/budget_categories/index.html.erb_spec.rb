require 'rails_helper'

RSpec.describe 'BudgetCategories#index', type: :feature do
  before(:each) do
    user = User.create!(name: 'tizu', email: 'milnenalebel2@gmail.com', password: '123456')
    login_as(user, scope: :user)
    @budget_categories = BudgetCategory.all
    @user = User.first
    visit budget_categories_path
  end

  it 'displays current user name' do
    expect(page).to have_content(@user.name)
  end

  it 'Log\'s current user out' do
    click_button 'Log out'
    expect(current_path).to match root_path
  end

  it 'Redirects to add new category page' do
    click_link 'Add New Category'
    expect(current_path).to match new_budget_category_path
  end
end
