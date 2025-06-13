require 'rails_helper'

RSpec.describe InterestService, type: :service do
  describe '.call' do
    context 'for a VIP user with a negative balance' do
      it 'succeeds' do
        vip_user = create(:user, :vip, balance: -100)
        result = InterestService.call(user: vip_user)
        expect(result).to be true
      end

      it 'creates a fee transaction correctly' do
        vip_user = create(:user, :vip, balance_cents: -1000)
        InterestService.call(user: vip_user)

        vip_user.reload
        new_transaction = vip_user.transactions.first
        expect(vip_user.balance_cents).to eq(-1001)
        expect(new_transaction.transaction_type).to eq 'fee'
        expect(new_transaction.description).to eq 'TAXA DE JUROS SOBRE SALDO NEGATIVO'
        expect(new_transaction.value_cents).to eq(-1)
      end

      it 'when return is false' do
        vip_user = create(:user, :vip, balance_cents: -1000)
        service = InterestService.new(user: vip_user)

        allow(service.interest_transaction).to receive(:save!).and_raise(
          ActiveRecord::RecordInvalid.new(service.interest_transaction)
        )

        expect(service.call).to be_an_instance_of ActiveRecord::RecordInvalid
      end
    end

    context 'not elible users' do
      it 'VIP user with a positive balance' do
        vip_user_positive_balance = create(:user, :vip, balance: 5000)

        expect { InterestService.call(user: vip_user_positive_balance) }.not_to change(Transaction, :count)
      end

      it 'regular user' do
        regular_user_in_debt = create(:user, :regular, balance: -5000)

        expect { InterestService.call(user: regular_user_in_debt) }.not_to change(Transaction, :count)
      end
    end
  end
end
