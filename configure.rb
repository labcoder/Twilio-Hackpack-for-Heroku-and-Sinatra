=begin
  This script will configure Twilio for your runtime environment.
  Just run this file: ruby configure.rb and set up your Twilio credentials.
=end

puts "Enter your twilio SID:"
TWILIO_ACCOUNT_SID = STDIN.gets.chomp()

puts "Enter your twilio auth token:"
TWILIO_AUTH_TOKEN = STDIN.gets.chomp()

ENV['TWILIO_ACCOUNT_SID'] = TWILIO_ACCOUNT_SID
ENV['TWILIO_AUTH_TOKEN'] = TWILIO_AUTH_TOKEN