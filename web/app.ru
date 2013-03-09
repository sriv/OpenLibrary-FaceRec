require File.expand_path('../Recognizer.rb', __FILE__)
require File.expand_path('../Reserver.rb', __FILE__)
require File.expand_path('../UserLookup.rb', __FILE__)

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

	map "/reserve" do
		run Reserver.new
	end

end

map "/user" do
	run UserLookup.new
end

map "/scripts" do
	run Rack::Directory.new(File.expand_path("./scripts"))
end

map "/css" do
	run Rack::Directory.new(File.expand_path("./css"))
end

map "/img" do
	run Rack::Directory.new(File.expand_path("./img"))
end
