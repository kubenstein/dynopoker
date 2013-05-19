DynoPoker
=============

Dynopoker is a gem which prevent your Heroku dyno from falling asleep.

Inspired and sponsored by [http://wakemydyno.com](http://wakemydyno.com)

Idea
-------
Dynopoker will command your app to ping itself every hour.

Installation
-------
Put this line into your `Gemfile`:

	gem 'dynopoker', :git => 'git://github.com/kubenstein/dynopoker.git'

( In future Dynopoker will be pushed to official gem repository, so not git url will be required )

Usage
-----
Add this configuration to your config file:

	Dynopoker.configure do |config|
  		config.address = 'http://dynopoker.com'
	#  config.enable = false # default is true
	#  config.poke_frequency = 123 # default is 3600s (1hour)
	end
	
