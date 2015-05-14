#https://github.com/gmailgem/gmail --gem used
require 'gmail'
require 'csv'
require 'io/console' #for hidden password input

class Email
  def initialize(user_name, password)
    @gmail = Gmail.connect!(user_name, password)
    @recipients = []
  end

  def get_recipients
    @gmail.label("Sent").emails.each do |email|
      push_recipients_to_array(email[:to]) if email.message.to
      push_recipients_to_array(email[:cc]) if email.message.cc
    end
    
    check_recipients_present
    @gmail.logout
  end

  private

  def push_recipients_to_array(email)
    email.each do |mail|
      @recipients << { "Email" =>  mail.mailbox.concat("@").concat(mail.host), "Name" => mail.first }
    end
  end

  def check_recipients_present
    unless @recipients.empty?
      @recipients.uniq! {|arr| arr["Email"]}
      add_recipients_to_file
    end
  end

  def add_recipients_to_file
    headers = ['Email', 'Name']
    CSV.open('email.csv', 'wb', {write_headers: true ,headers: headers}) do |csv|
      @recipients.each do |arr|
        csv << arr.values_at(*headers)
      end
    end
  end
end
