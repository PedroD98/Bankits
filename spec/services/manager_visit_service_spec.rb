require 'rails_helper'

describe ManagerVisitService, type: :service do
  context '.call' do
    it 'when return is false' do
      user = create(:user, :vip, balance: 100)
      valid_date = (Date.current + 3.days).to_s
      service = ManagerVisitService.new(user: user, scheduled_visit_date_param: valid_date)

      allow(service.manager_visit_transaction).to receive(:save!).and_raise(
        ActiveRecord::RecordInvalid.new(service.manager_visit_transaction)
      )

      expect(service.call).to be false
    end

    it 'when user is regular' do
      user = create(:user, balance: 100)
      valid_date = (Date.current + 3.days).to_s
      service = ManagerVisitService.new(user: user, scheduled_visit_date_param: valid_date)
      expect(service.call).to be false
    end
  end
end
