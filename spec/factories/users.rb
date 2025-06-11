FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:acc_number) { |n| (10000 + n).to_s }
    password { '1234' }
    balance_cents { 0 }
    user_type { :regular }

    trait :vip do
      user_type { :vip }
    end
  end
end
