require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should define_enum_for(:user_type).with_values(regular: 0, vip: 2) }
    it { should validate_presence_of(:acc_number) }
    it { should validate_uniqueness_of(:acc_number).case_insensitive }
    it { should validate_numericality_of(:balance_cents) }
    it { should validate_presence_of(:balance_cents) }
    it { should validate_presence_of(:password) }
    it { should have_many(:transactions) }


    context 'acc_number format' do
      it { should allow_value('12345').for(:acc_number) }
      it { should_not allow_value('123').for(:acc_number) }
      it { should_not allow_value('123456').for(:acc_number) }
      it { should_not allow_value('abcdE').for(:acc_number) }
    end

    context 'password format' do
      it { should allow_value('1234').for(:password) }
      it { should_not allow_value('123').for(:password) }
      it { should_not allow_value('12345').for(:password) }
      it { should_not allow_value('abcD').for(:password) }
    end
  end

  describe 'money-rails' do
    it 'converts value correctly when balance attribute is passed' do
      user = build(:user, balance: 49.99)

      expect(user.balance_cents).to eq 4999
    end

    it 'balance is a Money object' do
      user = build(:user, balance_cents: 4999)

      expect(user.balance).to be_an_instance_of Money
      expect(user.balance.format).to eq "R$ 49,99"
    end
  end
end
