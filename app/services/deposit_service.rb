
class DepositService < ApplicationService
  attr_reader :deposit_transaction

  def initialize(user:, value_param:)
    @user = user
    @value_param = value_param
    @deposit_transaction = @user.transactions.build
  end

  def call
    @amount = sanitize_and_validate_value(value_param: @value_param, transaction: @deposit_transaction)
    return false unless @amount
    update_records
  end

  private

  def update_records
    begin
      ActiveRecord::Base.transaction do
        @user.lock!
        new_balance = @user.balance + Money.from_amount(@amount, @user.balance.currency)
        @user.update!(balance: new_balance)
        create_deposit
      end
      true

    rescue ActiveRecord::RecordInvalid => e

      @deposit_transaction.errors.merge!(e.record.errors)
      false
    end
  end

  def create_deposit
    @deposit_transaction.attributes = {
      value: @amount,
      transaction_type: :deposit,
      description: "DEPÓSITO",
      processed_at: Time.current
    }
    @deposit_transaction.save!
  end
end
