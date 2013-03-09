require 'wrest'

class Book
  include DataMapper::Resource

  property :id, Serial, :required => true
  property :isbn, String, :index => true, :required => true, :length => 255
  property :title, String, :required => true, :length => 255
  property :author, String, :required => true, :length => 255
  property :photo_remote_url, String, :length => 255
  has n, :book_copies
  has n, :reservations  
  has n, :tag

  def self.create_from_google_api(isbn)
    params = details_from_google(isbn) || {:isbn => isbn, :title => 'N/A', :author => 'N/A'}
    Book.new(params).tap do |b|
      b.book_copies << BookCopy.new
    end if params
  end

  def self.details_from_google(isbn)
    items = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&fields=items(id,volumeInfo(authors,description,imageLinks,industryIdentifiers,title))".to_uri.get.deserialise["items"]
    return nil if items.nil?
    tags = "https://www.googleapis.com/books/v1/volumes/#{items[0]['id']}".to_uri.get.deserialise["volumeInfo"]
    response = items[0]["volumeInfo"]
    {}.tap do |p|
      p[:isbn] = isbn
      p[:title] = response["title"]
      p[:author] = response["authors"].join(", ")
      p[:photo_remote_url] = response["imageLinks"]["thumbnail"] if response["imageLinks"]
      p[:tag] = tags["categories"]
    end
  end

  def update_tags
    items = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&fields=items(id)".to_uri.get.deserialise["items"]
    return nil if items.nil?
    tags = "https://www.googleapis.com/books/v1/volumes/#{items[0]['id']}?fields=volumeInfo(categories)".to_uri.get.deserialise["volumeInfo"]
    return nil if tags.nil? || tags.empty?
    self.tag = tags["categories"].map {|e| e.split('/').pop.strip}.uniq.map { |e| Tag.new(:name => e, :book => self) }
  end
end
