require 'spec_helper'
require_relative '../lib/email'

RSpec.describe Email do

  before(:each) do

    #mock gmails connect! method
    allow(Gmail).to receive(:connect!).and_return(gmail = double('Gmail'))
    @email = Email.new('amolishere77', 'uamol@12345')
    allow(gmail).to receive(:label).with('Sent').and_return(sent_mails = double('Gmail::Mailbox'))

    #sent mails have two emails with to and cc(i.e first_email & second_email)
    first_email = double(Gmail::Message)
    second_email = double(Gmail::Message)
    allow(sent_mails).to receive(:emails).and_return([first_email, second_email])
    allow(first_email).to receive(:message).and_return(message1 = double(Mail::Message))
    allow(message1).to receive(:to).and_return(to_message1 = double(Mail::AddressContainer))
    allow(message1).to receive(:cc).and_return(cc_message1 = double(Mail::AddressContainer))
    allow(second_email).to receive(:message).and_return(message2 = double(Mail::Message))
    allow(message2).to receive(:to).and_return(to_message2 = double(Mail::AddressContainer))
    allow(message2).to receive(:cc).and_return(cc_message2 = double(Mail::AddressContainer))

    #first sent mail recipients data
    first_email_to_data = double(Net::IMAP::Address)
    first_email_cc_data = double(Net::IMAP::Address)
    allow(first_email).to receive(:to).and_return([first_email_to_data])
    allow(first_email).to receive(:cc).and_return([first_email_cc_data])
    allow(first_email_to_data).to receive(:mailbox).and_return(first_email_to_data_mailbox = 'amolishere7')
    allow(first_email_to_data).to receive(:host).and_return(first_email_to_data_host = 'gmail.com')
    allow(first_email_to_data).to receive(:first).and_return(first_email_to_data_name = 'Amol Udage')
    allow(first_email_cc_data).to receive(:mailbox).and_return(first_email_cc_data_mailbox = 'viky56')
    allow(first_email_cc_data).to receive(:host).and_return(first_email_cc_data_host = 'gmail.com')
    allow(first_email_cc_data).to receive(:first).and_return(first_email_cc_data_name = 'Viky ')

    #second sent mail recipients data
    second_email_to_data = double(Net::IMAP::Address)
    second_email_cc_data = double(Net::IMAP::Address)
    allow(second_email).to receive(:to).and_return([second_email_to_data])
    allow(second_email).to receive(:cc).and_return([second_email_cc_data])
    allow(second_email_to_data).to receive(:mailbox).and_return(second_email_to_data_mailbox = 'viky56')
    allow(second_email_cc_data).to receive(:mailbox).and_return(second_email_cc_data_mailbox = 'vijay14')
    allow(second_email_to_data).to receive(:host).and_return(second_email_to_data_host = 'gmail.com')
    allow(second_email_cc_data).to receive(:host).and_return(second_email_cc_data_host = 'joshsoftware.com')
    allow(second_email_to_data).to receive(:first).and_return(second_email_to_data_name = 'Viky ')
    allow(second_email_cc_data).to receive(:first).and_return(second_email_cc_data_name = 'Akshay b')
    allow(gmail).to receive(:logout)
  end

  it "initially recipients array should be empty" do
    expect(@email.instance_variable_get('@recipients')).to be_empty
  end

  it "raises error when given Gmail account credentials is invalid" do
    allow(Gmail).to receive(:connect!).with('amoldu', 'amolishere').and_raise("Gmail::Client::AuthorizationError")
    expect { Gmail.connect!('amoldu', 'amolishere') }.to raise_error("Gmail::Client::AuthorizationError")
  end

  it "push email id and name into array after #get_recipients called" do
    @email.get_recipients
    recipients = @email.instance_variable_get('@recipients')
    expect(recipients).not_to be_empty
    expect(recipients.first['Email']).not_to be_empty
  end

  it "check uniqueness of recipients" do
    @email.get_recipients
    recipients = @email.instance_variable_get('@recipients')
    file = CSV.open('recipients.csv', 'r')
    expect(recipients.uniq { |arr| arr['Email'] }.length).to eq recipients.length
    expect(recipients.length).to eq file.count - 1
  end

end
