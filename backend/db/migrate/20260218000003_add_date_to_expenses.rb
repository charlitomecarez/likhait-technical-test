class AddDateToExpenses < ActiveRecord::Migration[7.2]
  def change
    add_column :expenses, :date, :date, null: false, after: :amount
  end
end