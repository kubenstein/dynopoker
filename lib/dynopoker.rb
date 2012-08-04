require "dynopoker/version"
require 'open-uri'

module Dynopoker
  class << self
    attr_accessor :address, :disable
  end


  def self.start(address=nil)
    if ENV['stopDynoPoking'] || self.disable
      puts "Dynopoker: poking disabled"
      return
    end

    self.address = address unless address.nil?
    raise "Dynopoker: set address to poke first" if self.address.nil?
    Thread.new { while true do sleep(3600); poke;end }
  end

  def self.poke
    puts "Dynopoker: poking #{self.address}"
    open(self.address).content_type
  end
end
