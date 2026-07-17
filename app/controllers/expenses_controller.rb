class ExpensesController < ApplicationController
  before_action :set_budget_category
  before_action :set_expense, only: %i[edit update destroy]

  def index
    @expenses = @budget_category.expenses.newest_first
    @total = @expenses.sum(:amount)
  end

  def new
    @expense = @budget_category.expenses.new
  end

  def edit; end

  def create
    @expense = @budget_category.expenses.new(expense_params.merge(author: current_user))

    if @expense.save
      redirect_to budget_category_expenses_path(@budget_category), notice: t('.notice')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      redirect_to budget_category_expenses_path(@budget_category), notice: t('.notice')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to budget_category_expenses_path(@budget_category), notice: t('.notice'), status: :see_other
  end

  private

  def set_budget_category
    @budget_category = current_user.budget_categories.find(params[:budget_category_id])
  end

  def set_expense
    @expense = @budget_category.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:name, :amount)
  end
end
