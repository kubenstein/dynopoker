require 'dynopoker/version'
require 'open-uri'
require 'logger'

module Dynopoker

  def self.configure(poker_factory = Poker)
    poker_factory.new.tap { |p| yield p; p.start! }
  end

  class Poker
    attr_accessor :enable, :address, :poke_frequency, :logger
    alias_method :enable?, :enable

    def start!
      merge_default_options!
      start_poking_thread! if enable?
    end


    private

    def start_poking_thread!
      logger.info 'Dynopoker: starting thread'
      Thread.new { poking } or logger.error 'Dynopoker: error while starting thread'
    end

    def poking
      while true
        poke!
        sleep(poke_frequency)
      end
    end

    def poke!
      logger.info "Dynopoker: poking #{address}"
      open(address).status
    rescue Exception => exception
      logger.error "Dynopoker: poking error #{exception.class.name}: #{exception.message}"
    end

    def merge_default_options!
      self.poke_frequency ||= 1800
      self.logger ||= Logger.new($stdout)
      self.enable = enable.nil? ? true : enable
      raise('Dynopoker: no address provided!') if (enable? && !valid_address?)
    end

    def valid_address?
      address && !address.empty?
    end

  end

end