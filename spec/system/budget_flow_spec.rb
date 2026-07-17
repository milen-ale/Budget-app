require 'rails_helper'

RSpec.describe 'Budget flow', type: :system do
  it 'lets a visitor sign up, create a category and log an expense' do
    visit root_path
    click_link 'Sign up'

    fill_in 'Name', with: 'Alia'
    fill_in 'Email', with: 'alia@example.com'
    fill_in 'Password', with: 'password123', exact: true
    fill_in 'Password confirmation', with: 'password123'
    click_button 'Sign up'

    expect(page).to have_content('Hi, Alia')

    click_link 'Create your first category'
    fill_in 'Name', with: 'Groceries'
    choose(option: 'food')
    click_button 'Create category'

    expect(page).to have_content('Category created.')
    expect(page).to have_content('Groceries')

    click_link 'Groceries'
    click_link 'Add an expense'
    fill_in 'Name', with: 'Weekly shop'
    fill_in 'Amount', with: '42.50'
    click_button 'Add expense'

    expect(page).to have_content('Expense added.')
    expect(page).to have_content('Weekly shop')
    expect(page).to have_content('$42.50')
  end
end
