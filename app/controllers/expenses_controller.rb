class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: %i[show edit update destroy]

  # GET /expenses or /expenses.json
  def index
    @budget_category = BudgetCategory.find(params[:budget_category_id])
    @expenses = @budget_category.expenses.order('created_at desc')
    @total = @expenses.sum(:amount)
  end

  # GET /expenses/1 or /expenses/1.json
  def show
    @budget_category = BudgetCategory.find(params[:budget_category_id])
  end

  # GET /expenses/new
  def new
    @budget_categories = BudgetCategory.all.where(author_id: current_user.id)
    @budget_category = BudgetCategory.find(params[:budget_category_id])
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit; end

  # POST /expenses or /expenses.json
  def create
    @budget_category = BudgetCategory.find(params[:budget_category_id])
    @expense = Expense.new(expense_params)
    respond_to do |format|
      if @expense.save
        BudgetCategoryExpense.create({ expense_id: @expense.id, budget_category_id: @budget_category.id })
        format.html do
          redirect_to budget_category_expenses_path(@budget_category), notice: 'Expense was successfully created.'
        end
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to expense_url(@expense), notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy

    respond_to do |format|
      format.format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = Expense.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def expense_params
    params.require(:expense).permit(:name, :amount, :author_id, budget_category_ids: [])
  end
end
