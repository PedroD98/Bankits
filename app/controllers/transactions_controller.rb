class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def deposit
    service = DepositService.new(user: current_user,
                                 value_param: params.require(:transaction)[:value])

    if service.call
      redirect_to root_path, notice: t('transactions.deposit.success')
    else
      flash.now[:alert] = t('transactions.deposit.error')
      @transactions = @user.transactions.order(processed_at: :desc)
      @deposit_transaction = service.deposit_transaction
      @withdraw_transaction = Transaction.new
      render 'statements/index', status: :unprocessable_entity
    end
  end

  def withdraw
  end

  private

  def set_current_user
    @user = current_user
  end
end
