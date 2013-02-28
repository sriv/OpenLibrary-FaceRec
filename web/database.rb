require 'rubygems'
require 'bundler'
Bundler.require

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://root@localhost/openlib')

Dir["./models/*.rb"].each { |model| require model }
DataMapper.finalize
