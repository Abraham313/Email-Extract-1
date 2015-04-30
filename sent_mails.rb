#https://github.com/gmailgem/gmail --gem used
require 'gmail'

class Email
  def initialize(user_name, password)
    @gmail = Gmail.connect(user_name, password)
    @array = Hash.new
  end

  def get_mails
    File.open('email.csv', 'w') do |file|
      file << ["Email, Name"]

      @gmail.label("Sent").emails.each do |email|
        recipients_from_to(email[:to]) if email.message.to
        recipients_from_to(email[:cc]) if email.message.cc
      end

      file << @array.to_a

      @gmail.logout
      file.close
    end
  end

  private

  def recipients_from_to(email)
    email.each do |mail|
      @array[mail.mailbox.concat("@").concat(mail.host)] = mail.first
    end
  end

end

puts "Enter user name:"
user_name = gets.chomp
puts "Enter password:"
password = gets.chomp

@email = Email.new(user_name, password)
@email.get_mails
