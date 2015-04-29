#https://github.com/gmailgem/gmail --gem used
require 'gmail'

class Email
  def initialize(user_name, password)
    @gmail = Gmail.connect(user_name, password)
  end

  def get_mails
    File.open('email.csv', 'w') do |file|
      file << "Name, Email"
      @gmail.label("Sent").emails.each do |email|
        file << email.message.to
        file << email.message.cc
      end
    end
  end

end

puts "Enter user name:"
user_name = gets.chomp
puts "Enter password:"
password = gets.chomp

@email = Email.new(user_name, password)
@email.get_mails

