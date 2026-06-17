class MakePayerNameNullableOnExpenses < ActiveRecord::Migration[7.2]
  def change
    change_column_null :expenses, :payer_name, true
  end
end