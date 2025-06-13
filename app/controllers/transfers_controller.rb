class TransfersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def create
    params = sanitized_transfer_params
    transfer_service = TransferService.new(sender: @user,
                                           value_param: params[:value],
                                           counterparty_acc_number: params[:counterparty_acc_number])

    if transfer_service.call
      redirect_to root_path, notice: t('transfers.create.success')
    else
      flash.now[:alert] = t('transfers.create.error')
      @user.reload
      @transactions = @user.transactions.order(processed_at: :desc)
      @deposit_transaction = Transaction.new
      @withdraw_transaction = Transaction.new
      @transfer_transaction = transfer_service.transfer_sent_transaction
      render 'statements/index', status: :unprocessable_entity
    end
  end

  def sanitized_transfer_params
    params.require(:transaction).permit(:value, :counterparty_acc_number)
  end

  def set_current_user
    @user = current_user
  end
end
