#take inputs from user

require_relative './email'
require 'highline/import'

user_name = ask("Enter your username:") { |input| input.echo = true }
password = ask("Enter your password:") { |input| input.echo = "*" }

trap("INT") { puts 'Exited without sign in'; exit }

begin
  email = Email.new(user_name, password)
  email.get_recipients
rescue Gmail::Client::AuthorizationError => e
  puts e.message
rescue Gmail::Client::ConnectionError => e
  puts e.message
end

