class Api::ExpensesController < ApplicationController
  def index
    expenses = Expense.includes(:category).order(created_at: :desc)

    if params[:year].present? && params[:month].present?
      year = params[:year].to_i
      month = params[:month].to_i

      start_date = Date.new(year, month, 1)
      end_date = start_date.end_of_month

      expenses = expenses.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    end

    render json: expenses.map { |expense| format_expense(expense) }
  end

  def create
    expense = Expense.new(expense_params)

    if (date = parse_date)
      expense.created_at = date
      expense.updated_at = date
    end

    if expense.save
      render json: format_expense(expense), status: :created
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    expense = Expense.find(params[:id])

    attributes = expense_params.to_h
    if (date = parse_date)
      attributes[:created_at] = date
    end

    if expense.update(attributes)
      render json: format_expense(expense)
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    expense = Expense.find(params[:id])
    expense.destroy
    head :no_content
  end

  private

  def expense_params
    params.require(:expense).permit(:description, :amount, :category_id, :payer_name)
  end

  # The form sends a `date`; the schema stores it as created_at.
  def parse_date
    raw = params.dig(:expense, :date)
    return nil if raw.blank?

    Time.zone.parse(raw.to_s)
  rescue ArgumentError
    nil
  end

  def format_expense(expense)
    {
      id: expense.id,
      description: expense.description,
      amount: expense.amount.to_f,
      category: expense.category.name,
      payer_name: expense.payer_name,
      date: expense.created_at.to_date.to_s,
      created_at: expense.created_at,
      updated_at: expense.updated_at
    }
  end
end
