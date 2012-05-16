=begin
  Hackpack Configure
  A script to configure your TwiML apps and Twilio phone numbers to use in
  your hackpack's Heroku app.
  
  USAGE:
  
  Just run this file:
    ruby configure.rb
=end

puts "Enter your twilio SID:"
TWILIO_ACCOUNT_SID = STDIN.gets.chomp()

puts "Enter your twilio auth token:"
TWILIO_AUTH_TOKEN = STDIN.gets.chomp()

ENV['TWILIO_ACCOUNT_SID'] = TWILIO_ACCOUNT_SID
ENV['TWILIO_AUTH_TOKEN'] = TWILIO_AUTH_TOKEN