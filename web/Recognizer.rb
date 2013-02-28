require File.expand_path('../../lib/face.rb', __FILE__)
require 'base64'
require 'tempfile'
require './database'
require 'dm-serializer/to_json'

class Recognizer
	def initialize
		@client = Face.get_client()
		@user_ids = User.all(:location => 'chennai').map {|x| x.sky_uid }
	end

	def call(env)
		@req = Rack::Request.new(env)

		if @req.post?
			uridata = @req.POST['image'].split(',').pop
			file = Tempfile.new(['user','.png'])
			file_path = file.path
			begin
				file.write(Base64.decode64( uridata))
			ensure
				file.close
			end
			detection_response = @client.faces_recognize(:file => File.open(file_path, 'rb'), :uids => @user_ids)
			file.unlink
			if (detection_response['status'] == 'success')
				user_id = [detection_response['photos'].first['tags'].first['uids'].first['uid']]
				user = User.first(:sky_uid => user_id)
				[200, {"Content-Type" => "text/plain"}, [user.to_json(:methods => [:book, :full_name])]]
			else
				[404, {"Content-Type" => "text/plain"}, ['Person not found!']]
			end
		end
	end
end