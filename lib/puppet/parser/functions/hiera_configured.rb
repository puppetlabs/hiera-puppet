#
# hiera_configured.rb
#

module Puppet::Parser::Functions
  newfunction(:hiera_configured, :type => :rvalue, :doc => <<-EOS
This function attempts to run the :hiera function against the argument you
provide to determine if it is fully configured.  Returns a boolean.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "hiera_configured(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    begin
      if function_hiera([arguments[0]])
        true
      else
        false
      end 
    rescue
      false
    end
  end
end

# vim: set ts=2 sw=2 et :
