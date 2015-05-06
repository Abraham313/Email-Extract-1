require "spec_helper"
require_relative '../lib/sent_mails'

RSpec.describe Email do

  before(:each) do
    @gmail = Gmail.connect("amoludage7@gmail.com", "9860666535143")
  end

  it 'user has logged in if valid data' do
    expect(@gmail.logged_in?).to eq true
  end

  it 'login failed if invalid data' do
    expect { Email.new("amoludage7@gmail.com", "986066535143") }.to raise_error(Gmail::Client::AuthorizationError)
  end

  it 'error response message' do
    expect { Email.new("amoludi@jms.com", "kdld") }.to raise_error(/Couldn't login to given Gmail account/)
  end

end
