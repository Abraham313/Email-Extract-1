#https://github.com/gmailgem/gmail --gem used
require 'gmail'
require 'csv'
require 'byebug'

class Email
  def initialize(user_name, password)
    @gmail = Gmail.connect!(user_name, password)
    @recipients = CSV.read('recipients.csv').to_h
  end

  def get_recipients
    previous_email = nil

    trap("INT") do
      File.open('interrupt.txt', 'wb') { |file| file.write(Marshal.dump(previous_email.date)) } if previous_email
      add_recipients_to_file if @recipients
      exit
    end

    begin
      date = Marshal.load(File.read('interrupt.txt'))
    rescue ArgumentError
      p 'Initial fetching...'
    end

    @gmail.label("Sent").emails_in_batches(after: date) do |email|
      previous_email = email
      push_recipients_to_array(email.to) if email.message.to
      push_recipients_to_array(email.cc) if email.message.cc
    end

    add_recipients_to_file if @recipients
    @gmail.logout
  end

  private

  def push_recipients_to_array(email)
    email.each do |mail|
      @recipients[mail.mailbox.concat('@').concat(mail.host)] =  mail.first
      puts 'writting...'
      sleep 0.8
    end
  end

  def add_recipients_to_file
    headers = ['Email', 'Name']
    CSV.open('recipients.csv', 'w', {write_headers: true, headers: headers}) do |csv|
      @recipients.each do |arr|
        csv << arr
      end
    end
  end
end
