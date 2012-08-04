require "dynopoker/version"
require 'open-uri'

module Dynopoker
  class << self
    attr_accessor :address, :disable
  end


  def self.start(address=nil)
    self.address = address unless address.nil?
    raise "Dynopoker: set address to poke first" if self.address.nil?

    if ENV['stopDynoPoking'] || self.disable
      puts "Dynopoker: poking disabled"
    else
      Thread.new { while true do sleep(3600); poke; end }
    end
  end

  def self.poke
    puts "Dynopoker: poking #{self.address}"
    open(self.address).content_type
  end
end
