require "spec_helper"
require_relative '../lib/Email'

RSpec.describe Email do

  it "properly logs in to valid Gmail account" do
    user = Gmail.connect("amoludage7", "9860666535143")
    expect(user).to be_logged_in
  end

  it "raises error when given Gmail account is invalid" do
    expect { Email.new("amoludage70", "986066535143") }.to raise_error(Gmail::Client::AuthorizationError)
  end

  context "#get_recipients" do
    before do
      @gmail = Gmail.connect("amoludage7", "9860666535143")
      @recipients = []
    end

    it { expect(@recipients.empty?).to eq true }
    it { expect(@gmail.logged_in?).to eq true }
    it { expect(@gmail.username).to eq "amoludage7@gmail.com"}
  end
end
