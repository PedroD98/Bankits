class InterestService < ApplicationService
  attr_reader :interest_transaction
  def initialize(user:)
    @user = user
    @interest = user.balance.abs * 0.001
    @interest_transaction = @user.transactions.build
  end

  def call
    return if @interest == 0 || @user.regular? || @user.balance > 0
    update_records
  end

  def update_records
    begin
      ActiveRecord::Base.transaction do
        @user.lock!
        @user.update!(balance: @user.balance - @interest)
        create_interest_transaction
      end
    rescue ActiveRecord::RecordInvalid => e
      e
    end
  end

  def create_interest_transaction
    @interest_transaction.attributes = {
      value: @interest * -1,
      transaction_type: :fee,
      description: "TAXA DE JUROS SOBRE SALDO NEGATIVO",
      processed_at: Time.current
    }
    @interest_transaction.save!
  end
end
