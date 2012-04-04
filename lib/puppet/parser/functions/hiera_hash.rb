module Puppet::Parser::Functions
    newfunction(:hiera_hash, :type => :rvalue) do |*args|
        if args[0].is_a?(Array)
            args = args[0]
        end

        raise(Puppet::ParseError, "Please supply a parameter to perform a Hiera lookup") if args.empty?

        key = args[0]
        default = args[1]
        override = args[2]

        configfile = File.join([File.dirname(Puppet.settings[:config]), "hiera.yaml"])

        raise(Puppet::ParseError, "Hiera config file #{configfile} not readable") unless File.exist?(configfile)
        raise(Puppet::ParseError, "You need rubygems to use Hiera") unless Puppet.features.rubygems?

       begin
         # Try normal gem loading
         require 'hiera'
         require 'hiera/scope'
       rescue LoadError
         # If this fails revert to the gem inside this module
         hiera_gem_path = File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','hiera-gem','lib'))
         Puppet.warning("Loading hiera gem from inside the hiera-puppet module")

         # Add the load path for loading hiera.rb
         $LOAD_PATH.unshift(hiera_gem_path) unless $LOAD_PATH.include?(hiera_gem_path)
         require 'hiera'
         Puppet.debug("Hiera Gem Path added: #{hiera_gem_path}")

         # Add the load path for loading hiera/scope.rb
         hiera_scope_gem_path = File.expand_path(File.join(File.dirname(__FILE__),'..','..','..'))
         $LOAD_PATH.unshift(hiera_scope_gem_path) unless $LOAD_PATH.include?(hiera_scope_gem_path)
         require 'hiera/scope'
         Puppet.debug("Hiera Scope Gem Path added: #{hiera_scope_gem_path}")
       end

        config = YAML.load_file(configfile)
        config[:logger] = "puppet"

        hiera = Hiera.new(:config => config)

        if self.respond_to?("{}")
            hiera_scope = self
        else
            hiera_scope = Hiera::Scope.new(self)
        end

        answer = hiera.lookup(key, default, hiera_scope, override, :hash)

        raise(Puppet::ParseError, "Could not find data item #{key} in any Hiera data file and no default supplied") if answer.empty?

        answer
    end
end
