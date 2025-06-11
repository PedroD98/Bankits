class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :receiver, null: true, foreign_key: { to_table: :users }
      t.datetime :processed_at, null: false
      t.integer :transaction_type, null: false, default: 0
      t.string :description

      t.timestamps
    end

    add_monetize :transactions, :value, currency: { present: false }, amount: { null: false, default: 0 }
  end
end
