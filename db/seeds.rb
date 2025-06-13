
puts 'Seeds: creating users...'

User.find_or_create_by!(acc_number: '12345') do |user|
  user.first_name = 'Pedro'
  user.last_name = 'Ivo'
  user.password = '1111'
  user.password_confirmation = '1111'
  user.user_type = :regular
  user.balance = 50
end

User.find_or_create_by!(acc_number: '54321') do |user|
  user.first_name = 'Ana'
  user.last_name = 'Maria'
  user.password = '1111'
  user.password_confirmation = '1111'
  user.user_type = :vip
  user.balance = 1000
end

puts 'Seeds: complete!'
puts 'Check see db/seeds.rb for users login details'
