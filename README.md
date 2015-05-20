DynoPoker [![Build Status](https://travis-ci.org/kubenstein/dynopoker.png?branch=master)](https://travis-ci.org/kubenstein/dynopoker)
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

```ruby
Dynopoker.configure do |config|
  config.address = 'http://wakemydyno.com'
  #  config.enable = false # default is true
  #  config.poke_frequency = 123 # default is 1800s (30min)
  #  config.should_poke = Proc.new{ (8..19).include?(Time.now.hour) } # default is Proc.new { true } (always poke)
end
```

TODO
-----
Dynopoker is already doing what it was designed for. No extra features are needed. Code is very simple and well written.
I recently added specs but I feel that those specs could be written better. Feel free to contribute.
