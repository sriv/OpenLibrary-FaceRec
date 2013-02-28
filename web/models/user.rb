class User
  include DataMapper::Resource

  property :id, Serial, :required => true
  property :employee_id, Integer, :unique => true, :required => true, :messages => {
      :presence => "Employee Id must not be blank",
      :is_number => "Employee Id must be an Integer",
      :is_unique => "Employee Id already exists in the system"
  }
  property :first_name, String, :required => true
  property :last_name, String, :required => true
  property :sky_uid, String, :required => true
  property :location, String

  has n, :reservations, :state => :issued

  has n, :book, :through => :reservations
  
  def full_name
    "#{first_name} #{last_name}"
  end
end