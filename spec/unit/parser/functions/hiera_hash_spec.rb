require 'puppet'
require 'hiera'
require 'spec_helper'

describe 'Puppet::Parser::Functions' do
  describe "#hiera_hash" do
    before :each do
      @scope = Puppet::Parser::Scope.new
      configfile = File.join([File.dirname(Puppet.settings[:config]), "hiera.yaml"])
      Hiera.any_instance.stubs(:lookup).returns({}) # We don't test what Hiera returns
      File.stubs(:exist?).with(configfile).returns(true)
      File.stubs(:exist?).with("/var/lib/hiera/common.yaml").returns(true)
      YAML.stubs("load_file").returns( {:backends => ["yaml"], :hierarchy => "common", :logger => "console"})
    end
    it 'should exist' do
      Puppet::Parser::Functions.function(:hiera_hash).should == 'function_hiera_hash'
    end
    describe 'when accepting arguments it' do
      before :each do
        Puppet::Parser::Functions.function(:hiera_hash)
      end
      it 'should require a key argument' do
        expect { @scope.function_hiera_hash([]) }.should raise_error(Puppet::ParseError)
      end
      it 'should optionally take a default hash value' do
        @scope.function_hiera_hash(['key', {'key' => 'default'}])
      end
      it 'should accept an empty hash default value' do
        @scope.function_hiera_hash(['key', {}])
      end
      it 'should deny a non-hash default value' do
        expect { @scope.function_hiera_hash(['key', 'default']) }.should raise_error(Puppet::ParseError)
      end
      it 'should optionally take a default value and override level' do
        @scope.function_hiera_hash(['key', {'key' => 'default'}, 'common'])
      end
      it 'should accept an empty override level for empty variables' do
        @scope.function_hiera_hash(['key', {'key' => 'default'}, ''])
      end
    end
  end
end
