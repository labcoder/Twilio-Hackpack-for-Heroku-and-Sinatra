=begin
  Hackpack Configure
  A script to configure your TwiML apps and Twilio phone numbers to use in
  your hackpack's Heroku app.

  USAGE:

  See what this thing can do:
    ruby configure.rb -h | --help

  Let me figure out what needs to be done:
    ruby configure.rb

  Set up an app with a new app ID and number:
    ruby configure.rb -n | --new

  Set up app with specific App Sid:
    ruby configure.rb -a APxxxxxxxxxxxxxx | --app APxxxxxxxxxxxxxx

  Set up app with Specific Twilio Number:
    ruby configure.rb -c +15556667777 | --caller +15556667777

  Set up app with custom domain:
    ruby configure.rb -d example.com | --domain example.com
=end

require 'trollop'

opts = Trollop::options do
  version "Twilio HackPack for Heroku and Sinatra v0.1 (c) 2012 Oscar Sanchez"
  banner "USAGE: ruby configure.rb [options]\n" \
        "where [options] are:"
  opt :new, "We need to set up a new AppSID and Number"
  opt :app, "Use this Twilio App SID", :type => :string
  opt :caller, "Use this Twilio Number", :type => :string
  opt :domain, "Use this custom Domain", :type => :string
end

#p opts

=begin
puts "Enter your twilio SID:"
TWILIO_ACCOUNT_SID = STDIN.gets.chomp()

puts "Enter your twilio auth token:"
TWILIO_AUTH_TOKEN = STDIN.gets.chomp()

ENV['TWILIO_ACCOUNT_SID'] = TWILIO_ACCOUNT_SID
ENV['TWILIO_AUTH_TOKEN'] = TWILIO_AUTH_TOKEN
=end