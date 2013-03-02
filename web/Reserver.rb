class Reserver

	def call(env)
		@req = Rack::Request.new(env)

		if @req.post?
			p @req.POST
			load_user_and_book
			load_messages
			return [404, {"Content-Type" => "text/plain"}, [@messages[404]]] if @user.nil? || @book.nil?
			criteria = {:user => @user, :book => @book, :state => :issued}
			@reservation = get_reservation criteria
			@reservation.save
			[200, {"Content-Type" => "text/plain"}, [@messages[@reservation.state]]]
		else
			[405, {"Content-Type" => "text/plain"}, [@messages[405]]]
		end

	end

	private

	def load_user_and_book
	  load_user
	  load_book
	end

	def load_user
	  @user = User.first(:employee_id => @req.POST['employee_id'])
	end

	def load_book
	  @book = Book.first(:isbn => @req.POST['isbn']) || Book.create_from_google_api(@req.POST['isbn'])
	  p @book
	end

	def load_messages
	  @messages = YAML::load(File.read(File.expand_path('config/en.yml','.')))
	end

	def get_reservation criteria
	  reservation = Reservation.first(criteria)
	  reservation.forward! unless reservation.nil?
	  reservation ||= Reservation.create(criteria)
	  return reservation
	end
end