#https://github.com/gmailgem/gmail --gem used
require 'gmail'

class Email
  def initialize(user_name, password)
    @gmail = Gmail.connect(user_name, password)
    @array = []
  end

  def get_mails
    File.open('email.csv', 'w') do |file|
      file << "Name, Email"

      @gmail.label("Sent").emails.each do |email|
        recipients_from_to(email) if email.message.to
        recipients_from_cc(email) if email.message.cc
      end
      file << @array.uniq
      @gmail.logout
      file.close
    end
  end

  private

  def recipients_from_to(email)
    email[:to].each do |mail|
      @array << "#{mail.first}, #{mail.mailbox.concat("@").concat(mail.host)}"
    end
  end

  def recipients_from_cc(email)
    email[:cc].each do |mail|
      @array << "#{mail.first}, #{mail.mailbox.concat("@").concat(mail.host)}"
    end
  end

end

puts "Enter user name:"
user_name = gets.chomp
puts "Enter password:"
password = gets.chomp

@email = Email.new(user_name, password)
@email.get_mails



#p email.header_fields.select{ |f| f.name == "To" }.first
#file << email.message.to
#file << email.message.cc
