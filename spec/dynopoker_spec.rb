#encoding: UTF-8
require 'spec_helper'
require 'ostruct'


describe Dynopoker do

  subject { Dynopoker }
  let(:fake_poker_class) { double('FakePokerClass', :new => fake_poker) }
  let(:fake_logger) { double }
  let(:fake_poker) { OpenStruct.new(:address => nil, :enable => nil, :poke_frequency => nil, :logger => nil, :start! => nil) }

  context 'configuration' do

    it 'should pass config vars during configuration' do
      new_instance_of_poker = subject.configure(fake_poker_class) do |config|
        config.address = 'http://test.org'
        config.enable = false
        config.poke_frequency = 123
        config.logger = fake_logger
      end

      new_instance_of_poker.address.should eq 'http://test.org'
      new_instance_of_poker.enable.should be_false
      new_instance_of_poker.poke_frequency.should eq 123
      new_instance_of_poker.logger.should eq fake_logger
    end

    it 'should pass start poking!' do
      fake_poker.any_instance.should_receive(:start!).once
      subject.configure(fake_poker) {}
    end

  end

  context 'asset precompile process' do
    it 'should not start while in asset precompile process' do
      fake_poker.any_instance.should_not_receive(:start!)
      subject.configure(fake_poker, '/bin/rake') {}
    end

    it 'should start while not in asset precompile process' do
      fake_poker.any_instance.should_receive(:start!).once
      subject.configure(fake_poker, '/bin/rails') {}
    end
  end

end