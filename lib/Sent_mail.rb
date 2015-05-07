require_relative "./Email"

class Sent_mail
end

puts "Enter user name:"
user_name = gets.chomp
puts "Enter password:"
password = STDIN.noecho(&:gets).chomp

begin
  email = Email.new(user_name, password)
  email.get_recipients
rescue Gmail::Client::AuthorizationError => e
  puts e.message
end

