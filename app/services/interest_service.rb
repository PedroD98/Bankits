class InterestService < ApplicationService
  def initialize(vip_user:)
    @vip_user = vip_user
    @interest = vip_user.balance.abs * 0.001
  end

  def call
    return if @interest == 0
    update_records
  end

  def update_records
    ActiveRecord::Base.transaction do
      @vip_user.lock!
      @vip_user.update!(balance: @vip_user.balance - @interest)
      create_interest_transaction
      true
    end
  end

  def create_interest_transaction
    @vip_user.transaction.build(
      value: @interest * -1,
      transaction_type: :fee,
      description: "TAXA DE JUROS SOBRE SALDO NEGATIVO",
      processed_at: Time.current
    )
  end
end
