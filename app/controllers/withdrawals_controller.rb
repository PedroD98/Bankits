class WithdrawalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def create
    withdraw_service = WithdrawService.new(user: @user, value_param: sanitized_value_params)

    if withdraw_service.call
      redirect_to root_path, notice: t('withdrawals.success')
    else
      flash.now[:alert] = t('withdrawals.error')
      @transactions = @user.transactions.order(processed_at: :desc)
      @deposit_transaction = Transaction.new
      @transfer_transaction = Transaction.new
      @withdraw_transaction = withdraw_service.withdraw_transaction
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
