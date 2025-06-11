class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: 'User', optional: true
  enum :transaction_type, {
    deposit: 0,
    withdraw: 1,
    transfer_sent: 3,
    transfer_received: 4,
    fee: 5,
    manager_visit: 6
  }
  monetize :value_cents

  validates :receiver, presence: true, if: -> { transfer_sent? || transfer_received? }
  validates :description, :processed_at, presence: true
end
