require 'rails_helper'

describe DepositService, type: :service do
  context '.call' do
    it 'when return is false' do
      user = create(:user)
      service = DepositService.new(user: user, value_param: "100")

      allow(service.deposit_transaction).to receive(:save!).and_raise(
        ActiveRecord::RecordInvalid.new(service.deposit_transaction)
      )

      expect(service.call).to be false
    end
  end
end
