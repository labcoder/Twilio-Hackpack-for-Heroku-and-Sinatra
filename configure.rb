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
   --voice, -v <s>:   Use this url for voice (default: /voice)
     --sms, -m <s>:   Use this url for sms (default: /sms)
     --version, -e:   Print version and exit
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
  opt :voice, "Use this url for voice", :type => :string, :default => '/voice'
  opt :sms, "Use this url for sms", :type => :string, :default => '/sms'
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
    puts("Please enter your Twilio Account SID:")
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
    puts("Please enter your Twilio AUTH Token:")
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
  posBegin = git_config.index("heroku.com")
  posEnd = git_config.index(".git", posBegin+1)
  subdomain = git_config[posBegin+11, posEnd-posBegin-11]
rescue
  @log.error("Could not find Heroku remote in your .git config. " \
              "Have you created the Heroku app?")
  exit
end
@log.debug("Heroku remote found: #{subdomain}")
host = "http://#{subdomain}.herokuapp.com"
@log.debug("Returning full host: #{host}")

# Configure TwiML App----------------------------------------------------------
voice_url = host+opts[:voice]
sms_url = host+opts[:sms]
if opts[:app_given]
  @log.info("Setting up request urls for app sid: #{opts[:app]}")
  begin
    @app = @client.account.applications.get(opts[:app])
    @app.update(
                    :voice_url => voice_url, :sms_url => sms_url,
                    :friendly_name => "HackPack for Heroku and Sinatra")
    @log.debug("Updated app sid: #{opts[:app]}")
  rescue => err
    if err.to_s["HTTP ERROR 404"]
      @log.error("This app sid was not found: #{opts[:app]}")
      exit
    else
      @log.error("An error occured when setting the request urls: #{err}")
      exit
    end
  end
else
  @log.debug("Asking user to create new app sid...")
  count = 0
  while count < 4 && !@app
    count+=1
    puts("Your didn't provide an app sid. Want to create a TwiML app? [y/n]")
    choice = STDIN.gets.chomp()
    choice.strip!
    if choice == 'y'
      begin
        @log.info("Creating new TwiML app...")
        @app = @client.account.applications.create(
                    :voice_url => voice_url, :sms_url => sms_url,
                    :friendly_name => "HackPack for Heroku and Sinatra2")
        puts @app
        break
      rescue => err
        @log.error("Twilio app could not be creted :(")
        exit
      end
    elsif choice == 'n' || count == 4
      raiseError("app sid")
    else
      @log.warn("Please enter either 'y' or 'n'")
    end
  end
  @log.info("Application created: #{@app.sid}")
end