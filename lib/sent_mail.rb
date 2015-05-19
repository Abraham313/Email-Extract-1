#take inputs from user

require_relative './email'

puts "Enter user name:"
user_name = gets.chomp
puts "Enter password:"
system 'stty -echo'
password = gets.chomp
system 'stty echo'

begin
  email = Email.new(user_name, password)
  email.get_recipients
rescue Gmail::Client::AuthorizationError => e
  puts e.message
end

