class StatementsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @transactions = @user.transactions.order(processed_at: :desc)
    @deposit_transaction = Transaction.new
    @withdraw_transaction = Transaction.new
  end
end
