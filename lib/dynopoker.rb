require "dynopoker/version"
require 'dynopoker/configuration'
require 'open-uri'

module Dynopoker
  class << self
    attr_accessor :configuration, :already_started
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration

    if configuration.should_poke? && !already_started
      self.already_started = true
      self.start
    end
  end

  def self.start
    configuration.logger.info 'Dynopoker: starting thread'
    Thread.new { poke } or configuration.logger.error 'Dynopoker: error while starting thread'
  end

  def self.poke
    while(true)
      begin
        configuration.logger.info "Dynopoker: poking #{self.configuration.address}"
        open(configuration.address).content_type
      rescue Exception => exception
        configuration.logger.error "Dynopoker: poking error #{exception.class.name}: #{exception.message}"
      end

      sleep(configuration.poke_frequency)
    end
  end

end

if defined? Rails
  require 'dynopoker/rails'
end

