class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def deposit
    deposit_service = DepositService.new(user: current_user,
                                         value_param: params.require(:transaction)[:value])

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
    withdraw_service = WithdrawService.new(user: @user, value_param: params.require(:transaction)[:value])

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

  private

  def set_current_user
    @user = current_user
  end
end
