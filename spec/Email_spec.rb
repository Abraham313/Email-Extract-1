require "spec_helper"
require_relative '../lib/Email'

RSpec.describe Email do
  before(:each) do
    @email = Email.new("amolishere7", "amol@12345")
  end

  it "properly logs in to valid Gmail account" do
    expect(@email.instance_variable_get('@gmail')).to be_logged_in
  end

  it "raises error when given Gmail account credentials is invalid" do
    expect { Email.new("amoludage70", "986066535143") }.to raise_error(Gmail::Client::AuthorizationError)
  end

  it "push email id and name into array after #get_recipients called" do
    recipients = @email.instance_variable_get('@recipients')
    gmail = @email.instance_variable_get('@gmail')
    expect(recipients).to be_empty
    @email.get_recipients
    expect(recipients).not_to be_empty
    expect(recipients.uniq { |arr| arr['Email'] }.length).to eq recipients.length
  end

  it "log out after #get_recipients complete" do
    gmail = @email.instance_variable_get('@gmail')
    @email.get_recipients
    expect(gmail).not_to be_logged_in
  end

  it "should open file and write into the file after #get_recipients called" do
    @email.get_recipients
    allow(File).to receive(:open).with('email.csv', 'wb')
  end
end
