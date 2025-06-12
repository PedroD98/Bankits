class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :counterparty, class_name: 'User', optional: true
  enum :transaction_type, {
    deposit: 0,
    withdraw: 1,
    transfer_sent: 3,
    transfer_received: 4,
    fee: 5,
    manager_visit: 6
  }
  monetize :value_cents

  validates :counterparty, presence: true, if: -> { transfer_sent? || transfer_received? }
  validates :description, :processed_at, presence: true
  validates :value_cents, numericality: { greater_than: 0 }, if: -> { deposit? || transfer_received? }
  validates :value_cents, numericality: { less_than: 0 }, if: -> { withdraw? || transfer_sent? || fee? || manager_visit? }
end
