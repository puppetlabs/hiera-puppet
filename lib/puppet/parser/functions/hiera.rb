module Puppet::Parser::Functions
    newfunction(:hiera, :type => :rvalue) do |*args|
        # Functions called from puppet manifests that look like this:
        #   lookup("foo", "bar")
        # internally in puppet are invoked:  func(["foo", "bar"])
        #
        # where as calling from templates should work like this:
        #   scope.function_lookup("foo", "bar")
        #
        #  Therefore, declare this function with args '*args' to accept any number
        #  of arguments and deal with puppet's special calling mechanism now:
        if args[0].is_a?(Array)
            args = args[0]
        end

        key = args[0] || nil
        default = args[1] || nil
        override = args[2] || nil

        configfile = File.join([File.dirname(Puppet.settings[:config]), "hiera.yaml"])

        raise(Puppet::ParseError, "Hiera config file #{configfile} not readable") unless File.exist?(configfile)
        raise(Puppet::ParseError, "You need rubygems to use Hiera") unless Puppet.features.rubygems?

        require 'hiera'
        require 'hiera/scope'

        config = YAML.load_file(configfile)
        config[:logger] = "puppet"
        default = nil if default == config[:puppet][:nodefault] unless config[:puppet][:nodefault].nil?

        hiera = Hiera.new(:config => config)

        if self.respond_to?("[]")
            hiera_scope = self
        else
            hiera_scope = Hiera::Scope.new(self)
        end

        answer = hiera.lookup(key, default, hiera_scope, override, :priority)

        raise(Puppet::ParseError, "Could not find data item #{key} in any Hiera data file and no default supplied") unless answer

        return answer
    end
end
