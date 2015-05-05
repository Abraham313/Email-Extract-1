require_relative '../sent_mails'
RSpec.describe Email do

  before(:each) do
    @gmail = Gmail.connect("amoludage7@gmail.com", "9860666535143")
  end

  it 'has logged in' do
    expect(@gmail.logged_in?).to eq true
  end

end
