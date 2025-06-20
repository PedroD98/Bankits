class User < ApplicationRecord
  enum :user_type, { regular: 0, vip: 2 }
  monetize :balance_cents
  has_many :transactions

  devise :database_authenticatable, :registerable,
         :rememberable, authentication_keys: [:acc_number]

  validates :balance_cents, presence: true
  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, format: { with: /\A[\p{L}\s'-]+\z/ }

  validates :acc_number, presence: true, uniqueness: true
  validates :acc_number, format: { with: /\A\d{5}\z/ }

  validates :password, presence: true, on: :create
  validates :password, confirmation: true, on: :create
  validates :password, format: { with: /\A\d{4}\z/ }, on: :create


  def full_name
    first_name + ' ' + last_name
  end
end
