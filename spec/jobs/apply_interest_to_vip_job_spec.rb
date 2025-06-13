require 'rails_helper'

RSpec.describe ApplyInterestToVipJob, type: :job do
  it 'calls the InterestService for VIP users with a negative balance only' do
    vip_in_debt = create(:user, :vip, balance_cents: -1000)
    vip_ok = create(:user, :vip, balance_cents: 1000)

    expect(InterestService).to receive(:call).with(user: having_attributes(id: vip_in_debt.id)).once
    expect(InterestService).not_to receive(:call).with(user: vip_ok)
    ApplyInterestToVipJob.perform_now
  end
end
