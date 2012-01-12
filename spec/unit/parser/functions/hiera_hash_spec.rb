require 'puppet'
require 'hiera'
require 'spec_helper'

describe 'Puppet::Parser::Functions' do
  describe "#hiera_hash" do
    before :each do
      @scope = Puppet::Parser::Scope.new
    end
    it 'should exist' do
      Puppet::Parser::Functions.function(:hiera_hash).should == 'function_hiera_hash'
    end
    describe 'accepting arguments' do
      before :each do
        File.expects(:exist?).with(File.join([File.dirname(Puppet.settings[:config]), "hiera.yaml"])).returns(true)
        File.expects(:exist?).with("/var/lib/hiera/common.yaml").returns(true)
        YAML.stubs("load_file").returns({:backends => ["yaml"], :hierarchy => "common", :logger => "console"})
        #Hiera::Config.stubs("load").returns({:backends => ["yaml"], :hierarchy => "common", :logger => "console"})
        Puppet::Parser::Functions.function(:hiera_hash)
      end
      it 'should require a key argument' do
        expect { @scope.function_hiera_hash([]) }.should raise_error(Puppet::ParseError)
      end
      it 'should optionally take a default hash value' do
        @scope.function_hiera_hash(['key', {'key' => 'default'}]).should == { 'key' => 'default' }
      end
      it 'should accept an empty hash default value'
      it 'should deny a non-hash default value'
      it 'should optionally take a default value and override level'
      it 'should accept an empty override level'
    end
    describe 'returning answers' do
      it 'should return result'
      it 'should return default answer if no result'
      it 'should return result instead of default'
      it 'should return empty result'
      it 'should return empty default'
      it 'should not return nil result'
      it 'should not return nil default'
    end
  end
end
