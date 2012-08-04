require "dynopoker/version"
require 'open-uri'

module Dynopoker
  class << self
    attr_accessor :address, :disabled
  end


  def self.start(address=nil)
    unless should_poke?
      puts "Dynopoker: poking disabled"
      return
    end

    self.address = address unless address.nil?
    raise "Dynopoker: set address to poke first" if self.address.nil?
    Thread.new { while should_poke? do poke; sleep(3600); end }
    puts "Dynopoker: thread started"
  end

  def self.poke
    puts "Dynopoker: poking #{self.address}"
    open(self.address).content_type
  end

  def self.should_poke?
    !ENV['stopDynoPoking'] && !self.disabled
  end
end
