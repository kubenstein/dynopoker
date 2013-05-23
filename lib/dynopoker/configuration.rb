module Dynopoker
  class Configuration
    attr_accessor :address, :enable, :poke_frequency, :logger

    def initialize
      self.address = ''
      self.enable = true
      self.poke_frequency = 1800
      self.logger = Logger.new($stdout)
    end

    def should_poke?
      address.present? && enable && poke_frequency.present?
    end
  end
end
