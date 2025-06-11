require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should belong_to(:user) }
    it { should belong_to(:receiver).class_name('User').optional }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:processed_at) }
    it { should define_enum_for(:transaction_type).with_values(deposit: 0,
                                                               withdraw: 1,
                                                               transfer_sent: 3,
                                                               transfer_received: 4,
                                                               fee: 5,
                                                               manager_visit: 6
                                                              )}
    it { should validate_numericality_of(:value_cents) }
  end
end
