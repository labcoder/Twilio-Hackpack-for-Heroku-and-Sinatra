=begin
  Hackpack Configure
  A script to configure your TwiML apps and Twilio phone numbers to use in
  your hackpack's Heroku app.

  USAGE: ruby configure.rb [options]
  where [options] are:
           --new, -n:   We need to set up a new AppSID and Number
       --app, -a <s>:   Use this Twilio App SID
    --caller, -c <s>:   Use this Twilio Number
    --domain, -d <s>:   Use this custom Domain
       --version, -v:   Print version and exit
          --help, -h:   Show this message
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