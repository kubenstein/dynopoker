module Dynopoker
  module Rails
    def self.initialize
      Dynopoker.configure do |config|
        config.logger           = ::Rails.logger
      end
    end
  end
end

if defined?(Rails::Railtie)
  require 'dynopoker/railtie'
else
  Dynopoker::Rails.initialize
end

