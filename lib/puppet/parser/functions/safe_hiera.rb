#
# safe_hiera.rb
#

module Puppet::Parser::Functions
  newfunction(:safe_hiera, :type => :rvalue, :doc => <<-EOS
Calls hiera, but fails gracefully if hiera is misconfigured.
    EOS
  ) do |arguments|

    if arguments[1]
      begin
        function_hiera(arguments[0])
      rescue
        arguments[1]
      end
    else
      function_hiera(arguments[0])
    end

  end
end

# vim: set ts=2 sw=2 et :
