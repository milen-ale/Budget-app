require 'test_helper'

class BudgetCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @budget_category = budget_categories(:one)
  end

  test 'should get index' do
    get budget_categories_url
    assert_response :success
  end

  test 'should get new' do
    get new_budget_category_url
    assert_response :success
  end

  test 'should create budget_category' do
    assert_difference('BudgetCategory.count') do
      post budget_categories_url,
           params: { budget_category: { icon: @budget_category.icon, name: @budget_category.name } }
    end

    assert_redirected_to budget_category_url(BudgetCategory.last)
  end

  test 'should show budget_category' do
    get budget_category_url(@budget_category)
    assert_response :success
  end

  test 'should get edit' do
    get edit_budget_category_url(@budget_category)
    assert_response :success
  end

  test 'should update budget_category' do
    patch budget_category_url(@budget_category),
          params: { budget_category: { icon: @budget_category.icon, name: @budget_category.name } }
    assert_redirected_to budget_category_url(@budget_category)
  end

  test 'should destroy budget_category' do
    assert_difference('BudgetCategory.count', -1) do
      delete budget_category_url(@budget_category)
    end

    assert_redirected_to budget_categories_url
  end
end
