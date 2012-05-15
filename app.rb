require 'sinatra'
require 'twilio-ruby'

get '/' do
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