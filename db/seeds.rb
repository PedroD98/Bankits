# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts 'Seeds: creating users...'
User.create!(first_name: 'Pedro', last_name: 'Ivo', acc_number: '12345',
             password: '1111', balance_cents: 1250)


User.create!(first_name: 'Ana', last_name: 'Maria', acc_number: '54321',
             password: '1111', balance_cents: 5000, user_type: 2)
