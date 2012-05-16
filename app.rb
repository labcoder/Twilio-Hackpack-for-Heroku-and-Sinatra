require 'sinatra'
require 'twilio-ruby'

# A hack around multiple routes in Sinatra
def get_or_post(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

get_or_post '/' do
  @title = "Home"
  erb :home
end

get '/voice/?' do
  #build response
  response = Twilio::TwiML::Response.new do |r|
    r.Say 'Hello' , :voice => 'woman'
  end
  response.text
end