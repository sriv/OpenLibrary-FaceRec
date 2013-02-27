require File.expand_path('../utils', __FILE__)
require File.expand_path('../recognition', __FILE__)
require File.expand_path('../tags', __FILE__)

module Face
  module Client
    class Base
      
      attr_accessor :api_key, :api_secret

      include Face::Client::Utils
      include Face::Client::Recognition
      include Face::Client::Tags

      def initialize(opts={})
        opts.assert_valid_keys(:api_key, :api_secret)
        @api_key, @api_secret = opts[:api_key], opts[:api_secret]
      end

    end
  end
end