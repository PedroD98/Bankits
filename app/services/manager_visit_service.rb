class ManagerVisitService < ApplicationService
  attr_reader :manager_visit_transaction

  def initialize(user:, scheduled_visit_date_param:)
    @user = user
    @scheduled_visit_date_param = scheduled_visit_date_param
    @manager_visit_transaction = @user.transactions.build
  end

  def call
    validate_user_type
    validate_scheduled_visit_date
    return false if @manager_visit_transaction.errors.any?
    update_records
  end

  private

  def validate_scheduled_visit_date
    if @scheduled_visit_date_param.blank?
      @manager_visit_transaction.errors.add(:base, 'É necessário escolher uma data.')
    end

    @scheduled_visit_date_param = Date.parse(@scheduled_visit_date_param) rescue nil
    if @scheduled_visit_date_param.nil? || @scheduled_visit_date_param < Date.current
      @manager_visit_transaction.errors.add(:base, 'Não pode ser uma data passada.')
    end
  end

  def validate_user_type
    if @user.regular?
      @manager_visit_transaction.errors.add(:base, 'Apenas usuários VIP podem efetuar essa operação.')
    end
  end


  def update_records
    begin
      ActiveRecord::Base.transaction do
        @user.lock!
        @user.update!(balance: calculate_new_balance)
        create_manage_visit
      end
      true

    rescue ActiveRecord::RecordInvalid => e

      @manager_visit_transaction.errors.merge!(e.record.errors)
      false
    end
  end

  def calculate_new_balance
    @user.balance - Money.from_amount(50, @user.balance.currency)
  end

  def create_manage_visit
    @manager_visit_transaction.attributes = {
      value: -50,
      transaction_type: :manager_visit,
      description: "VISITA GERENCIAL AGENDADA PARA #{I18n.l(@scheduled_visit_date_param)}",
      scheduled_visit_date: @scheduled_visit_date_param,
      processed_at: Time.current
    }
    @manager_visit_transaction.save!
  end
end
