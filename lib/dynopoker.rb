require 'dynopoker/version'
require 'open-uri'
require 'logger'

module Dynopoker

  def self.configure(poker_factory = Poker, execution_flow = $0)
    poker_factory.new.tap do |p|
      yield p
      p.start! unless execution_flow =~ /rake/
    end
  end

  class Poker
    attr_accessor :enable, :address, :poke_frequency, :logger, :should_poke
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
        poke! if should_poke.call
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
      self.should_poke = Proc.new { true }
      raise('Dynopoker: no address provided!') if (enable? && !valid_address?)
    end

    def valid_address?
      address && !address.empty?
    end

  end

end
