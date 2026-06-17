class Expense < ApplicationRecord
  belongs_to :category

  validates :description, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :payer_name, presence: true
  validate :date_not_in_future

  private

  # The expense date is stored in created_at (see ExpensesController).
  # Expenses can only be recorded for today or a past date.
  def date_not_in_future
    return if created_at.blank?

    if created_at.to_date > Date.current
      errors.add(:base, "Date cannot be in the future. Please choose today or a past date.")
    end
  end
end
