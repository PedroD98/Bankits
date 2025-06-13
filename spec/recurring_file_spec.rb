# require 'rails_helper'

# RSpec.describe "Solid Queue Recurring Tasks Schedule" do
#   include ActiveJob::TestHelper
#   it "schedules the ApplyVipOverdraftFeeJob to run every minute" do
#     schedule_file = Rails.root.join('config', 'recurring.yml')

#     schedule_config = YAML.load_file(schedule_file)
#     task_config = schedule_config['development']['apply_vip_interest_fee']

#     expect(task_config['class']).to eq("ApplyInterestToVipJob")
#     expect(task_config['schedule']).to eq("every minute")
#   end
# end
