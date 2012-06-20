#Twilio HackPack for Heroku and Sinatra
An easy-to-use repo to kickstart your Twilio app using Sinatra and deploy onto Heroku.
This is a Ruby port of Rob Spectre's [Twilio Hackpack for Python](https://github.com/RobSpectre/Twilio-Hackpack-for-Heroku-and-Flask#twilio-hackpack-for-heroku-and-flask), so check that out if you don't like Ruby (what's wrong with you!?)

##Features:
What this can do for you!

+ Automatic Configuration - running configure.rb will help you set up your whole Twilio/Sinatra/Heroku app environment!
+ Local Development Easy - bundle install will help you get any necessary gems
+ Hackable - easy to read code and easy to modify all in app.rb
+ [Twilio Client](http://www.twilio.com/api/client) - Want to call something from your browser? Gotcha covered!
+ Testing - working on those... not ready yet

##Usage:
The hackpack contains endpoints for Twilio Voice and SMS apps. Check out how to edit the '/voice' and '/sms' routes in app.rb

Say an app that plays some Kooks:
```ruby
post '/voice/?' do
  response = Twilio::TwiML::Response.new do |r|
    r.Play "http://example.com/theKooks.mp3"
  end
  response.text
end
```
Or an app that will tell you how sweet this hackpack is:
```ruby
post '/sms/?' do
  respose = Twilio::TwiML::Response.new do |r|
    r.Sms "This Hackpack is pretty sweet!"
  end
  response.text
end
```
All regular Twilio, TwiML, and Ruby logic applies, and to get a better understanding on how to use the Twilio Ruby gem, check it out [here](https://github.com/twilio/twilio-ruby)

##Installation:
Step-by-step on how to deploy, configure, and develop using this hackpack.

###Getting Started
1) Grab latest source:
<pre>git clone git://github.com/labcoder/Twilio-Hackpack-for-Heroku-and-Sinatra.git</pre>

2) Navigate to folder and create a [Heroku](https://toolbelt.herokuapp.com/) Cedar stack:
<pre>heroku create --stack cedar</pre>

3) Configure your Twilio information:
Check out the Configuration section below

4) Deploy to Heroku:
<pre>git push heroku master</pre>

5) Check out your new app!
<pre>heroku open</pre>

###Configuration
You can use this hackpack with a ton of configurable options whether you have a Twilio number, application id, or not. To get a feel for what can happen, take a look at:
<pre>ruby configure.rb -h</pre>

####Automatic Configuration
You'll first want to run `bundle install` to obtain the required Ruby gems to get this hackpack up and running.
Other than that, the hackpack itself can do anything from buying you a new Twilio phone number, creating a new application, or configuring your account SID and auth token.

1) At the beginning, run:
<pre>ruby configure.rb --sid ACXXXXXXX --token YYYYYYYY</pre>

2) For local development, copy and paste the commands the configure script provides
<pre>
export TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxx
export TWILIO_AUTH_TOKEN=yyyyyyyyyyyyyyyyy
export TWILIO_APP_SID=APzzzzzzzzzzzzzzzzzz
export TWILIO_CALLER_ID=+15556667777
</pre>

3) Launch webserver:
<pre>foreman start</pre>

4) Tweak away on app.rb

##Questions:
If you have any questions/suggestions/feedback, email me at [oms1005@gmail.com](oms1005@gmail.com)

##To-Do:
+ Tests...
+ Modify app template for easier changes or adding of pages