require 'sinatra'

get '/' do
  @title = "Home"
  erb :home
end
