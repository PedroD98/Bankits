class ManagerVisitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_validate_current_user

  def new
    @manager_visit_transaction = Transaction.new
  end

  def create
    manager_visit_service = ManagerVisitService.new(user: @user, scheduled_visit_date_param: sanitized_schedule_visit_params)

    if manager_visit_service.call
      redirect_to root_path, notice: t('manager_visits.success')
    else
      flash.now[:alert] = t('manager_visits.error')
      @manager_visit_transaction = manager_visit_service.manager_visit_transaction
      render :new, status: :unprocessable_entity
    end
  end

  def sanitized_schedule_visit_params
    permitted_params = params.require(:transaction).permit(:scheduled_visit_date)
    permitted_params[:scheduled_visit_date]
  end

  def set_and_validate_current_user
    @user = current_user
    if @user.regular?
      flash[:alert] = t('manager_visits.invalid_user_message')
      redirect_to root_path
    end
  end
end
