FactoryBot.define do
  factory :user do
    first_name { 'Pedro Ivo' }
    last_name { 'Dias' }
    acc_number { '12345' }
    password { '1111' }
    balance_cents { 0 }
    user_type { 'regular' }
  end
end
