DynoPoker
=============

Dynopoker is a gem which prevent your Heroku dyno from falling asleep.

Inspired and sponsored by [http://wakemydyno.com](http://wakemydyno.com)

Idea
-------
Dynopoker will command your app to ping itself every 30 minutes.

Installation
-------
Put this line into your `Gemfile`:

	gem 'dynopoker'

Usage
-----
Add this configuration to your config file:

	Dynopoker.configure do |config|
  		config.address = 'http://wakemydyno.com'
	#  config.enable = false # default is true
	#  config.poke_frequency = 123 # default is 1800s (30min)
	end
	
