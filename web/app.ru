require File.expand_path('../Recognizer.rb', __FILE__)

require 'net-http-spy'


Net::HTTP.http_logger_options = {:body => true, :trace => true, :verbose => true}

default = Proc.new {|env| [200, {"Content-Type" => "text/html"}, File.new(File.expand_path("./index.html"),'rb')]}

map "/" do
	map "/" do
		run default
	end

	map "/recognize" do
		run Recognizer.new
	end
end

map "/scripts" do
	run Rack::Directory.new(File.expand_path("./scripts"))
end

map "/css" do
	run Rack::Directory.new(File.expand_path("./css"))
end
