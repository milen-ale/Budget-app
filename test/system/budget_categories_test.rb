require 'application_system_test_case'

class BudgetCategoriesTest < ApplicationSystemTestCase
  setup do
    @budget_category = budget_categories(:one)
  end

  test 'visiting the index' do
    visit budget_categories_url
    assert_selector 'h1', text: 'Budget categories'
  end

  test 'should create budget category' do
    visit budget_categories_url
    click_on 'New budget category'

    fill_in 'Icon', with: @budget_category.icon
    fill_in 'Name', with: @budget_category.name
    click_on 'Create Budget category'

    assert_text 'Budget category was successfully created'
    click_on 'Back'
  end

  test 'should update Budget category' do
    visit budget_category_url(@budget_category)
    click_on 'Edit this budget category', match: :first

    fill_in 'Icon', with: @budget_category.icon
    fill_in 'Name', with: @budget_category.name
    click_on 'Update Budget category'

    assert_text 'Budget category was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Budget category' do
    visit budget_category_url(@budget_category)
    click_on 'Destroy this budget category', match: :first

    assert_text 'Budget category was successfully destroyed'
  end
end
