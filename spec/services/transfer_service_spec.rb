require 'rails_helper'

describe TransferService, type: :service do
  context '.call' do
    it 'when return is false' do
      user = create(:user, balance: 1000)
      counterparty = create(:user)
      service = TransferService.new(sender: user, value_param: "100", counterparty_acc_number: counterparty.acc_number)

      allow(service.transfer_sent_transaction).to receive(:save!).and_raise(
        ActiveRecord::RecordInvalid.new(service.transfer_sent_transaction)
      )

      expect(service.call).to be false
    end

    it 'when value + fee exceeds regular user balance ' do
      user = create(:user, balance: 100)
      counterparty = create(:user)
      service = TransferService.new(sender: user, value_param: "95", counterparty_acc_number: counterparty.acc_number)

      expect(service.call).to be false
    end
  end
end
