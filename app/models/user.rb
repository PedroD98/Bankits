class User < ApplicationRecord
  enum :user_type, { regular: 0, vip: 2 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:acc_number]

  validates :acc_number, presence: true, uniqueness: true
end
