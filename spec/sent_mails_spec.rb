require_relative '../sent_mails'
RSpec.describe Email do

  before(:each) do
    @gmail = Gmail.connect("amoludage7@gmail.com", "9860666535143")
  end

  it 'has logged in' do
    expect(@gmail.logged_in?).to eq true
  end

  it 'response for invalid data' do
    gmail = Gmail.connect("amol@nd.cl", "djdweiuuo")
    expect(gmail.logged_in?).to eq false
  end

  it '#get_recipients' do
    @email = Email.new("amoludage7@gmail.com", "9860666535143")
    expect(@email.get_recipients.name).to eq "OK"
  end
end
