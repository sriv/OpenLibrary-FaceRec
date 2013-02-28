class Book
  include DataMapper::Resource

  property :id, Serial, :required => true
  property :isbn, String, :index => true, :required => true, :length => 255
  property :title, String, :required => true, :length => 255
  property :author, String, :required => true, :length => 255
  property :photo_remote_url, String, :length => 255
  has n, :book_copies
  has n, :reservation

  def self.create_from_google_api(isbn)
    params = details_from_google(isbn) || {:isbn => isbn, :title => 'N/A', :author => 'N/A'}
    Book.new(params).tap do |b|
      b.book_copies << BookCopy.new
    end if params
  end

  def self.details_from_google(isbn)
    items = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&fields=items(volumeInfo(authors,description,imageLinks,industryIdentifiers,title))".to_uri.get.deserialise["items"]
    return nil if items.nil?
    response = items[0]["volumeInfo"]
    {}.tap do |p|
      p[:isbn] = isbn
      p[:title] = response["title"]
      p[:author] = response["authors"].join(", ")
      p[:photo_remote_url] = response["imageLinks"]["thumbnail"] if response["imageLinks"]
    end
  end
end
