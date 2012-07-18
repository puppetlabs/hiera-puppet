describe 'Puppet::Parser::Functions#hiera_hash' do
  let(:scope) { PuppetlabsSpec::PuppetSeams.parser_scope }

  it 'should require a key argument' do
    expect { scope.function_hiera_hash([]) }.should raise_error(Puppet::ParseError)
  end

  it 'should raise a useful error when nil is returned' do
    Hiera.any_instance.expects(:lookup).returns(nil)
    expect { scope.function_hiera_hash("badkey") }.should raise_error(Puppet::ParseError, /Could not find data item badkey/ )
  end

  it 'should use the hash resolution_type' do
    Hiera.any_instance.expects(:lookup).with() { |*args| args[4].should be :hash }.returns({})
    scope.function_hiera_hash(['key'])
  end
end
