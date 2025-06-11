class RenameReceiverToCounterpartyInTransactions < ActiveRecord::Migration[8.0]
  def change
    rename_index :transactions, "index_transactions_on_receiver_id", "index_transactions_on_counterparty_id"
    rename_column :transactions, :receiver_id, :counterparty_id
  end
end
