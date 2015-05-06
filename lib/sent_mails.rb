#https://github.com/gmailgem/gmail --gem used
require 'gmail'
require 'csv'
require 'io/console' #for hidden password input

class Email
  def initialize(user_name, password)
    @gmail = Gmail.new!(user_name, password)
    @recipients = []
  end

  def get_recipients
    @gmail.label("Sent").emails.each do |email|
      push_recipients_to_array(email[:to]) if email.message.to
      push_recipients_to_array(email[:cc]) if email.message.cc
    end

    unless @recipients.empty?
      @recipients.uniq! {|arr| arr["Email"]}
      add_recipients_to_file
    end
    @gmail.logout
  end

  private

  def push_recipients_to_array(email)
    email.each do |mail|
      @recipients << { "Email" =>  mail.mailbox.concat("@").concat(mail.host), "Name" => mail.first }
    end
  end

  def add_recipients_to_file
    header =  ["Email", "Name"]
    File.open('email.csv', 'w') do |file|
      file.puts header.to_csv
      @recipients.each do |arr|
        file.puts header.map {|h| arr[h]}.to_csv
      end
      file.close
    end
  end
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
