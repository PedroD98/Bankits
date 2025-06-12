class WithdrawService < ApplicationService
  attr_accessor :withdraw_transaction

  def initialize(user:, value_param:)
    @user = user
    @value_param = value_param
    @withdraw_transaction = @user.transactions.build
  end

  def call
    amount = sanitize_and_validate_value(value_param: @value_param, transaction: @withdraw_transaction)
    return false unless amount
    amount *= -1
    set_attributes_to_withdraw(amount)
    update_records(amount)
  end

  private

  def set_attributes_to_withdraw(amount)
    @withdraw_transaction.attributes = {
      value: amount,
      transaction_type: :withdraw,
      description: 'SAQUE',
      processed_at: Time.current
    }
  end

  def update_records(amount)
    begin
      ActiveRecord::Base.transaction do
        @user.lock!
        new_balance = @user.balance + Money.from_amount(amount, @user.balance.currency)
        @user.update!(balance: new_balance)
        @withdraw_transaction.save!
      end
      true

    rescue ActiveRecord::RecordInvalid => e

      @withdraw_transaction.errors.merge!(e.record.errors)
      false
    end
  end
end
