require "spec_helper"
require_relative '../lib/Email'

RSpec.describe Email do

  it "properly logs in to valid Gmail account" do
    email = Email.new("amoludage7", "9860666535143")
    expect(email.instance_variable_get('@gmail')).to be_logged_in
    expect(email.instance_variable_get('@recipients')).to be_empty
  end

  it "Not logs in to invalid Gmail account credentials" do
    email = Email.new("amoludage7", "9860666535143")
    expect(email.instance_variable_get('@gmail')).to be_logged_in
  end

  it "raises error when given Gmail account credentials is invalid" do
    expect { Email.new("amoludage70", "986066535143") }.to raise_error(Gmail::Client::AuthorizationError)
  end

  context "#get_recipients" do
    before do
      @email = Email.new("amoludage7", "9860666535143")
      @email.get_recipients
    end

    it { expect(@email.instance_variable_get('@gmail')).not_to be_logged_in }
    it { expect(@email.instance_variable_get('@recipients')).not_to be_empty }
  end
end
