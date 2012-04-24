module Puppet::Parser::Functions
    newfunction(:hiera_include) do |*args|
        if args[0].is_a?(Array)
            args = args[0]
        end

        key = args[0]
        default = args[1]
        override = args[2]

        configfile = File.join([File.dirname(Puppet.settings[:config]), "hiera.yaml"])

        raise(Puppet::ParseError, "You need rubygems to use Hiera") unless Puppet.features.rubygems?

        require 'hiera'
        require 'hiera/scope'

        begin
            config = YAML.load_file(configfile)
        rescue
            Puppet.warning "Hiera config file #{configfile} not readable"
            config = {}
        end

        config[:logger] = "puppet"

        hiera = Hiera.new(:config => config)

        if self.respond_to?("[]")
            hiera_scope = self
        else
            hiera_scope = Hiera::Scope.new(self)
        end

        answer = hiera.lookup(key, default, hiera_scope, override, :array)

        raise(Puppet::ParseError, "Could not find data item #{key} in any Hiera data file and no default supplied") if answer.empty?

        method = Puppet::Parser::Functions.function(:include)
        send(method, answer)
    end
end
