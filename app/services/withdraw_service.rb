class WithdrawService < ApplicationService
  attr_reader :withdraw_transaction

  def initialize(user:, value_param:)
    @user = user
    @value_param = value_param
    @withdraw_transaction = @user.transactions.build
  end

  def call
    @amount = sanitize_and_validate_value(value_param: @value_param, transaction: @withdraw_transaction)
    return false unless @amount
    verify_user_balance if @user.regular?
    return false if @withdraw_transaction.errors.any?
    @amount *= -1
    update_records
  end

  private

  def verify_user_balance
    if Money.from_amount(@amount, @user.balance.currency) > @user.balance
      @withdraw_transaction.errors.add(:base, 'Saldo insuficiente.')
    end
  end

  def update_records
    begin
      ActiveRecord::Base.transaction do
        @user.lock!
        new_balance = @user.balance + Money.from_amount(@amount, @user.balance.currency)
        @user.update!(balance: new_balance)
        create_withdraw
      end
      true

    rescue ActiveRecord::RecordInvalid => e

      @withdraw_transaction.errors.merge!(e.record.errors)
      false
    end
  end

  def create_withdraw
    @withdraw_transaction.attributes = {
      value: @amount,
      transaction_type: :withdraw,
      description: 'SAQUE',
      processed_at: Time.current
    }
    @withdraw_transaction.save!
  end
end
