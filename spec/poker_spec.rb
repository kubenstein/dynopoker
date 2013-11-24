#encoding: UTF-8
require 'spec_helper'
require 'ostruct'


describe Dynopoker::Poker do

  context 'default params' do
    it 'should use default params if no other params are given' do
      subject.stub(start_poking_thread!: false, address: 'http://test.org')
      subject.start!
      subject.poke_frequency.should eq 1800
      subject.logger.class.name.should eq 'Logger'
      subject.enable.should be_true
    end
  end

  context 'no address provided error' do
    it 'should raise exception if address is not given' do
      expect { subject.start! }.to raise_error(Exception, 'Dynopoker: no address provided!')
    end

    it 'should raise exception if address is empty' do
      subject.stub(address: '')
      expect { subject.start! }.to raise_error(Exception, 'Dynopoker: no address provided!')
    end

    it 'should NOT raise exception if address is not given but poking is disabled' do
      subject.stub(enable: false)
      expect { subject.start! }.not_to raise_error(Exception, 'Dynopoker: no address provided!')
    end

    it 'should NOT raise exception if address is empty but poking is disabled' do
      subject.stub(enable: false, address: '')
      expect { subject.start! }.not_to raise_error(Exception, 'Dynopoker: no address provided!')
    end
  end

  context 'thread' do
    it 'should start thread' do
      subject.stub(address: 'http://test.org')
      Thread.should_receive(:new).once
      subject.start!
    end
  end

  context 'poking' do
    before do
      #
      # testing while(true) in separate thread can be really tuff task
      # first I skip thread itself by replacing 'start_poking_thread!' method with 'poking'
      def subject.start_poking_thread!; poking end

      #
      # then I need to break while true loop...
      # I replace sleep method in the loop to raise exception after x calls
      def subject.sleep(_)
        break_after_attempts = 2
        @x ||= 0
        raise('breaking while true loop') if ((@x+=1) == break_after_attempts)
      end

      #
      # One thing that can not be tested in this configuration is poking frequency
    end

    it 'should poke address' do
      stub_request(:get, 'http://test.org')
      subject.stub(address: 'http://test.org')

      expect {
        subject.start!
      }.to raise_error(Exception, 'breaking while true loop')

      WebMock.should have_requested(:get, 'http://test.org').twice
    end

    it 'should write to logger error if any exception was raised during poking' do
      fake_logger = double()
      fake_logger.stub(:info)
      fake_logger.stub(:error)
      fake_logger.should_receive(:error).with('Dynopoker: poking error Errno::ENOENT: No such file or directory - INVALID_ADDRESS').twice

      subject.stub(address: 'INVALID_ADDRESS', logger: fake_logger)
      expect {
        subject.start!
      }.to raise_error(Exception, 'breaking while true loop')
    end
  end

end