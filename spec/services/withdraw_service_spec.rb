require 'rails_helper'

describe WithdrawService, type: :service do
  context '.call' do
    it 'when return is false' do
      user = create(:user, balance: 200)
      service = WithdrawService.new(user: user, value_param: "100")

      allow(service.withdraw_transaction).to receive(:save!).and_raise(
        ActiveRecord::RecordInvalid.new(service.withdraw_transaction)
      )

      expect(service.call).to be false
    end
  end
end
