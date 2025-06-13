class AddScheduledVisitDateToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :scheduled_visit_date, :date
  end
end
