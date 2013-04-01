class UserTag
	include DataMapper::Resource
	property :id, Serial, :required => true
	property :count, Integer
	belongs_to :tag, :required => true
	belongs_to :user, :required => true
end