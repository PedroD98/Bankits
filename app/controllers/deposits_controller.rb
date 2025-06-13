class DepositsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def create
    deposit_service = DepositService.new(user: current_user, value_param: sanitized_value_params)

    if deposit_service.call
      redirect_to root_path, notice: t('deposits.success')
    else
      flash.now[:alert] = t('deposits.error')
      @transactions = @user.transactions.order(processed_at: :desc)
      @deposit_transaction = deposit_service.deposit_transaction
      @withdraw_transaction = Transaction.new
      @transfer_transaction = Transaction.new
      render 'statements/index', status: :unprocessable_entity
    end
  end

  def sanitized_value_params
    permitted_params = params.require(:transaction).permit(:value)
    permitted_params[:value]
  end

  def set_current_user
    @user = current_user
  end
end
