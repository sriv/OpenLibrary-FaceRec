require 'rubygems'
require 'rest_client'
require 'json'
require 'yaml'

require File.expand_path('../face/client', __FILE__)

module Face
  
  def self.get_client(opts={})
  	api_opts = YAML.load_file(File.expand_path('./skybiometry.yml'))
    Face::Client::Base.new(opts.merge(api_opts))
  end
  
end
