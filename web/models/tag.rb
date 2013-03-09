class Tag
	include DataMapper::Resource
	property :id, Serial, :required => true
	property :name, String, :index => true, :required => true, :length => 255
	belongs_to :book, :required => true
end