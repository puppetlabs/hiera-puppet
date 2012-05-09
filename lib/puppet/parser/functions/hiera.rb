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

        key = args[0]
        default = args[1]
        override = args[2]

        configfile = File.join([File.dirname(Puppet.settings[:config]), "hiera.yaml"])

        # As heira gets integrated into the workflow for Puppet, we should
        # expect users to be able to write modules using the hiera call and
        # upload those to the forge. At the same time we should expect that
        # a large number of hosts won't have the hiera library installed yet.
        # To enable this behavior, the hiera method call should allow module
        # writers to specify a default value. We then expect the following
        # behavior:
        #  * If no hiera.yaml is present and the default value is not set, fail.
        #  * If no hiera.yaml is present but there is a default value, opt for
        #    the default, and warn to log about the hiera config.
        #  * If the hiera.yaml is present but not readable, throw an error and
        #    stop.
        # We only want hiera to stop if the user has attempted to configure
        # hiera, at which point we can see that there is a config failure
        # and that we are not in our default install state.
        if default.nil? && !File.exist?(configfile)
          raise(Puppet::ParseError, "Hiera config file #{configfile} not readable")
        elsif !File.exist?(configfile)
          Puppet.warning "Hiera config file #{configfile} not readable, using default value"
          return default
        end

        begin
          require 'hiera'
          require 'hiera/scope'
        rescue LoadError
          raise(Puppet::ParseError, "Hiera lookup not supported without hiera library")
        end

        config = YAML.load_file(configfile)
        config[:logger] = "puppet"

        hiera = Hiera.new(:config => config)

        if self.respond_to?("[]")
            hiera_scope = self
        else
            hiera_scope = Hiera::Scope.new(self)
        end

        answer = hiera.lookup(key, default, hiera_scope, override, :priority)

        raise(Puppet::ParseError, "Could not find data item #{key} in any Hiera data file and no default supplied") if answer.nil?

        return answer
    end
end
