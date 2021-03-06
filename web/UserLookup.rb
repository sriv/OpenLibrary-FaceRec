class UserLookup

	def call(env)
		load_messages	
		@req = Rack::Request.new(env)
		if @req.get?
			user = User.first(:employee_id => @req.GET['employee_id'])
			return [404, {"Content-Type" => "text/plain"}, [@messages["unrecognized_user"]]] if user.nil? 
			[200, {"Content-Type" => "text/plain"}, [user.to_json(:methods => [:reserved_books, :full_name, :interests])]]
		else
			[405, {"Content-Type" => "text/plain"}, [@messages[405]]]
		end
	end

	private

	def load_messages
	  @messages = YAML::load(File.read(File.expand_path('config/en.yml','.')))
	end

end