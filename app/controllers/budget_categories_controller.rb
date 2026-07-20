class BudgetCategoriesController < ApplicationController
  before_action :set_budget_category, only: %i[edit update destroy]

  def index
    @budget_categories = current_user.budget_categories.with_spending_totals.newest_first
    @total_spent = current_user.total_spent
  end

  def new
    @budget_category = current_user.budget_categories.new
  end

  def edit; end

  def create
    @budget_category = current_user.budget_categories.new(budget_category_params)

    if @budget_category.save
      redirect_to budget_categories_path, notice: t('.notice')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @budget_category.update(budget_category_params)
      redirect_to budget_categories_path, notice: t('.notice')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget_category.destroy
    redirect_to budget_categories_path, notice: t('.notice'), status: :see_other
  end

  private

  # Scoping through current_user makes foreign IDs raise RecordNotFound (404).
  def set_budget_category
    @budget_category = current_user.budget_categories.find(params[:id])
  end

  def budget_category_params
    params.require(:budget_category).permit(:name, :icon)
  end
end
