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

Usage - Rails app on Thin server
-----

Add `Dynopoker.start` to the very end of your `config.ru` file, so it looks like:

	# This file is used by Rack-based servers to start the application.
	require ::File.expand_path('../config/environment',  __FILE__)
	run Dynopoker::Application
	
	Dynopoker.start
	
Next set your app url in `config/environments/production.rb` by adding:

	Dynopoker.address = 'http://dynopoker.herokuapp.com'

To prevent poking while you are in your development env, add

	Dynopoker.disabled = true

to your `config/environments/development.rb` file.

Usage - Rails app on Unicorn server
-----

To prevent pinging by every unicorn worker, pinging thread is launched only once. Your `config_unicorn.rb` should looks like:

	worker_processes 4
	timeout 30

	before_fork do |server, worker|
		if worker.nr == 0
			require ::File.expand_path('../environment',  __FILE__)
			Dynopoker.start
		end
	end

Next set your app url in `config/environments/production.rb` by adding:

	Dynopoker.address = 'http://dynopoker.herokuapp.com'

To prevent poking while you are in your development env, add

	Dynopoker.disabled = true

to your `config/environments/development.rb` file.

ENV['stopDynoPoking']
------------

You can disable poking, without changing app codes by setting `stopDynoPoking` env variable:

	heroku config:add stopDynoPoking=true
