class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def deposit
    deposit_service = DepositService.new(user: current_user, value_param: sanitized_value_params)

    if deposit_service.call
      redirect_to root_path, notice: t('transactions.deposit.success')
    else
      flash.now[:alert] = t('transactions.deposit.error')
      @transactions = @user.transactions.order(processed_at: :desc)
      @deposit_transaction = deposit_service.deposit_transaction
      @withdraw_transaction = Transaction.new
      render 'statements/index', status: :unprocessable_entity
    end
  end

  def withdraw
    withdraw_service = WithdrawService.new(user: @user, value_param: sanitized_value_params)

    if withdraw_service.call
      redirect_to root_path, notice: t('transactions.withdraw.success')
    else
      flash.now[:alert] = t('transactions.withdraw.error')
      @transactions = @user.transactions.order(processed_at: :desc)
      @deposit_transaction = Transaction.new
      @withdraw_transaction = withdraw_service.withdraw_transaction
      render 'statements/index', status: :unprocessable_entity
    end
  end

  def new_manager_visit
    @manager_visit_transaction = Transaction.new
  end

  def create_manager_visit
    manager_visit_service = ManagerVisitService.new(user: @user, scheduled_visit_date_param: sanitized_schedule_visit_params)

    if manager_visit_service.call
      redirect_to root_path, notice: t('transactions.create_manager_visit.success')
    else
      flash.now[:alert] = t('transactions.create_manager_visit.error')
      @manager_visit_transaction = manager_visit_service.manager_visit_transaction
      render :new_manager_visit, status: :unprocessable_entity
    end
  end

  private
  def set_current_user
    @user = current_user
  end

  def sanitized_schedule_visit_params
    permitted_params = params.require(:transaction).permit(:scheduled_visit_date)
    permitted_params[:scheduled_visit_date]
  end

  def sanitized_value_params
    permitted_params = params.require(:transaction).permit(:value)
    permitted_params[:value]
  end
end
