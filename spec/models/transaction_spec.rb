require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    subject { build(:transaction) }
    it { should belong_to(:user) }
    it { should belong_to(:counterparty).class_name('User').optional }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:processed_at) }
    it { should validate_numericality_of(:value_cents) }
    it { should define_enum_for(:transaction_type).with_values(deposit: 0,
                                                               withdraw: 1,
                                                               transfer_sent: 3,
                                                               transfer_received: 4,
                                                               fee: 5,
                                                               manager_visit: 6
                                                              )}
  end


  describe 'money-rails' do
    it 'converts value correctly when value attribute is passed' do
      transaction = build(:transaction, value: 10.00)

      expect(transaction.value_cents).to eq 1000
    end

    it 'value is a Money object' do
      transaction = build(:transaction, value_cents: 1000)

      expect(transaction.value).to be_an_instance_of Money
      expect(transaction.value.format).to eq "R$ 10,00"
    end
  end

  describe 'deposit validations' do
    subject { build(:transaction, transaction_type: :deposit) }
    it { should validate_numericality_of(:value_cents).is_greater_than(0) }
    it { should_not validate_presence_of(:counterparty) }
  end
end
