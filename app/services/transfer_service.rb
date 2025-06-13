class TransferService < ApplicationService
  attr_reader :transfer_sent_transaction

  def initialize(sender:, value_param:, counterparty_acc_number:)
    @sender = sender
    @counterparty_acc_number = counterparty_acc_number
    @value_param = value_param
    @transfer_sent_transaction = @sender.transactions.build
  end

  def call
    find_and_verify_counterparty
    @amount = sanitize_and_validate_value(value_param: @value_param, transaction: @transfer_sent_transaction)
    return false unless @amount
    @fee_amount = calculate_fee_amount
    if @sender.regular?
      validate_amount
      verify_sender_balance
    end
    return false if @transfer_sent_transaction.errors.any?
    update_records
  end

  private

  def validate_amount
    @transfer_sent_transaction.errors.add(:value, 'não pode exceder R$ 1000,00 para seu perfil') if @amount > 1000
  end

  def calculate_fee_amount
    return Money.from_amount(8, @sender.balance.currency) if @sender.regular?
    Money.from_amount((@amount * 0.008), @sender.balance.currency) if @sender.vip?
  end

  def find_and_verify_counterparty
    return @transfer_sent_transaction.errors.add(:base, 'Não é possível transferir para sua própria conta.') if @counterparty_acc_number == @sender.acc_number
    @counterparty = User.find_by(acc_number: @counterparty_acc_number)
    @transfer_sent_transaction.errors.add(:counterparty, 'não encontrado.') if @counterparty.nil?
  end

  def verify_sender_balance
    if Money.from_amount(@amount, @sender.balance.currency) > @sender.balance
      return @transfer_sent_transaction.errors.add(:base, 'Saldo insuficiente.')
    end

    if Money.from_amount(@amount, @sender.balance.currency) + @fee_amount > @sender.balance
      @transfer_sent_transaction.errors.add(:value, '+ Taxa de transferência (R$ 8,00) excede seu saldo')
    end
  end

  def update_records
    begin
      ActiveRecord::Base.transaction do
        @sender.lock!
        @counterparty.lock!
        @sender.update!(balance: calculate_new_sender_balance)
        @counterparty.update!(balance: calculate_new_counterparty_balance)
        create_transfer_sent
        create_transfer_fee
        create_transfer_received
      end
    true

    rescue ActiveRecord::RecordInvalid => e

      @transfer_sent_transaction.errors.merge!(e.record.errors)
      false
    end
  end

  def calculate_new_sender_balance
    @sender.balance - Money.from_amount(@amount, @sender.balance.currency) - @fee_amount
  end

  def calculate_new_counterparty_balance
    @counterparty.balance + Money.from_amount(@amount, @sender.balance.currency)
  end


  def create_transfer_sent
    @transfer_sent_transaction.attributes = {
      counterparty: @counterparty,
      value: @amount * -1,
      transaction_type: :transfer_sent,
      description: "TRANSFERÊNCIA ENVIADA PARA #{@counterparty.full_name.upcase}",
      processed_at: Time.current
    }
    @transfer_sent_transaction.save!
  end

  def create_transfer_received
    @counterparty.transactions.create!(
      counterparty: @sender,
      value: @amount,
      transaction_type: :transfer_received,
      description: "TRANSFERÊNCIA RECEBIDA DE #{@sender.full_name.upcase}",
      processed_at: Time.current
    )
  end

  def create_transfer_fee
    @sender.transactions.create!(
      value: @fee_amount * -1,
      transaction_type: :fee,
      description: 'TAXA DE TRANSFERÊNCIA',
      processed_at: Time.current
    )
  end
end
