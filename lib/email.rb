#https://github.com/gmailgem/gmail --gem used
require 'gmail'
require 'csv'

class Email
  def initialize(user_name, password)
    @gmail = Gmail.connect!(user_name, password)
    @recipients = Hash.new
  end

  def get_recipients
    @recipients = CSV.read('recipients.csv').to_h
    previous_email = nil

    trap("INT") do
      File.open('interrupt.txt', 'wb') { |file| file.write(Marshal.dump(previous_email.date)) } if previous_email
      add_recipients_to_file if @recipients
      exit
    end

    date = get_last_updated_date

    @gmail.label("Sent").emails_in_batches(after: date) do |email|
      previous_email = email
      push_recipients_to_hash(email.to) if email.message.to
      push_recipients_to_hash(email.cc) if email.message.cc
    end

    add_recipients_to_file if @recipients
    @gmail.logout
  end

  private

  def get_last_updated_date
    begin
      date = Marshal.load(File.read('interrupt.txt'))
    rescue ArgumentError
      puts 'Connecting...'; sleep 1.5
      puts 'Initial fetching...'
      nil
    end
  end

  def push_recipients_to_hash(email)
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
