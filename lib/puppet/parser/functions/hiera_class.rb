module Puppet::Parser::Functions
    newfunction(:hiera_class) do |*args|
        if args[0].is_a?(Array)
            args = args[0]
        end

        key = args[0]
        default = args[1]
        override = args[2]

        configfile = File.join([File.dirname(Puppet.settings[:config]), "hiera.yaml"])

        raise(Puppet::ParseError, "Hiera config file #{configfile} not readable") unless File.exist?(configfile)
        raise(Puppet::ParseError, "You need rubygems to use Hiera") unless Puppet.features.rubygems?

        require 'hiera'
        require 'hiera/scope'

        config = YAML.load_file(configfile)
        config[:logger] = "puppet"

        hiera = Hiera.new(:config => config)

        if self.respond_to?("[]")
            hiera_scope = self
        else
            hiera_scope = Hiera::Scope.new(self)
        end

        # First, look for parameterized class definitions in hashes, if no
        # hashes found, then try looking again with an array search.
        begin
            answer = hiera.lookup(key, default, hiera_scope, override, :hash)
        rescue Exception
            answer = hiera.lookup(key, default, hiera_scope, override, :array)
        end

        raise(Puppet::ParseError, "Could not find data item #{key} in any Hiera data file and no default supplied") if answer.empty?

        # The 'false' disables lazy evaluation.
        klasses = compiler.evaluate_classes(answer, self, false)
    end
end
