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
     --token, -t <s>:   Use this Twilio Auth Token
       --sid, -s <s>:   Use this Twilio Account SID
       --version, -v:   Print version and exit
          --help, -h:   Show this message
=end

require 'trollop'
require 'logger'
require 'twilio-ruby'

# Command line parsing stuff---------------------------------------------------
opts = Trollop::options do
  version "Twilio HackPack for Heroku and Sinatra v0.1 (c) 2012 Oscar Sanchez"
  banner "USAGE: ruby configure.rb [options]\n" \
        "where [options] are:"
  opt :new, "We need to set up a new AppSID and Number"
  opt :app, "Use this Twilio App SID", :type => :string
  opt :caller, "Use this Twilio Number", :type => :string
  opt :domain, "Use this custom Domain", :type => :string
  opt :token, "Use this Twilio Auth Token", :type => :string
  opt :sid, "Use this Twilio Account SID", :type => :string
end

# For error messages-----------------------------------------------------------
def raiseError(s)
  @log.error "Sorry, you need to set up your #{s}"
  exit
end

# Change this to a file if you'd like------------------------------------------
@log = Logger.new(STDOUT)
@log.formatter = proc do |severity, datetime, progname, msg| 
  "#{severity}:\t#{msg}\n"
end
@log.info("Configuring your Twilio HackPack...")
@log.debug("Checking if credentials are set...")

# Set up account SID-----------------------------------------------------------
ENV['TWILIO_ACCOUNT_SID'] = opts[:sid] if opts[:sid_given]
if ENV['TWILIO_ACCOUNT_SID'].nil? || ENV['TWILIO_ACCOUNT_SID'].empty?
  count = 0
  while count < 4
    puts "Please enter your Twilio Account SID:"
    x = STDIN.gets.chomp()
    if !x.empty?
      ENV['TWILIO_ACCOUNT_SID'] = x
      break
    end
    count+=1
  end
end
raiseError("Twilio Account SID") if ENV['TWILIO_ACCOUNT_SID'].nil? \
                                 || ENV['TWILIO_ACCOUNT_SID'].empty?
@log.info("Account SID found and set")

# Set up account AUTH TOKEN----------------------------------------------------
ENV['TWILIO_AUTH_TOKEN'] = opts[:token] if opts[:token_given]
if ENV['TWILIO_AUTH_TOKEN'].nil? || ENV['TWILIO_AUTH_TOKEN'].empty?
  count = 0
  while count < 4
    puts "Please enter your Twilio AUTH Token:"
    x = STDIN.gets.chomp()
    if !x.empty?
      ENV['TWILIO_AUTH_TOKEN'] = x
      break
    end
    count+=1
  end
end
raiseError("Twilio Account AUTH Token") if ENV['TWILIO_AUTH_TOKEN'].nil? \
                                 || ENV['TWILIO_AUTH_TOKEN'].empty?
@log.info("Account AUTH found and set")

# Create Twilio client---------------------------------------------------------
@log.debug("Creating Twilio client...")
@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"] \
                                  ,ENV["TWILIO_AUTH_TOKEN"]

# Get Heroku info--------------------------------------------------------------
git_config_path = './.git/config'
@log.debug("Getting hostname from git config file: #{git_config_path}")
begin
  git_config = File.open(git_config_path).read()
rescue
  @log.error("Could not find .git config. Does it exist?")
  exit
end
@log.debug("Finding Heroku in remote in git configuration...")
begin
  posBegin = git_config.index "heroku.com"
  posEnd = git_config.index ".git", posBegin+1
  subdomain = git_config[posBegin+11, posEnd-posBegin-11]
rescue
  @log.error("Could not find Heroku remote in your .git config. " \
              "Have you created the Heroku app?")
  exit
end
@log.debug("Heroku remote found: #{subdomain}")
host = "http://#{subdomain}.herokuapp.com"
@log.debug("Returning full host: #{host}")
#p opts

=begin
puts "Enter your twilio SID:"
TWILIO_ACCOUNT_SID = STDIN.gets.chomp()

puts "Enter your twilio auth token:"
TWILIO_AUTH_TOKEN = STDIN.gets.chomp()

ENV['TWILIO_ACCOUNT_SID'] = TWILIO_ACCOUNT_SID
ENV['TWILIO_AUTH_TOKEN'] = TWILIO_AUTH_TOKEN
=end