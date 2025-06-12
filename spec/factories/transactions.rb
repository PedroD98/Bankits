FactoryBot.define do
  factory :transaction do
    user
    value_cents { rand(1000..50000) }
    processed_at { Time.current }
    description { 'DEPÓSITO' }
    transaction_type { :deposit }

    trait :withdraw do
      transaction_type { :withdraw }
      description { 'Saque' }
    end

    trait :manager_visit do
      transaction_type { :manager_visit }
      description { 'Visita do seu gerente' }
      value_cents { 5000 }
    end

    trait :transfer do
      transaction_type { :transfer_sent }
      description { 'Transferência enviada' }
      association :counterparty, factory: :user
    end
  end
end
