require File.expand_path('../lib/face.rb', __FILE__)
require 'net-http-spy'

Net::HTTP.http_logger_options = {:body => true, :trace => true, :verbose => true}

client = Face.get_client()

test_file = File.new('/Users/srikanth/hobby_projects/OpenLibrary-FaceRec/web/temp.png', 'rb')

user_ids = ['someone@openlibrary', 'sambu@openlibrary', 'selva@openlibrary', 'tom@openlibrary', 'jerry@openlibrary', 'mickey@openlibrary', 'minnie@openlibrary', 'srikanth@openlibrary']

client.faces_recognize(:file => test_file, :uids => user_ids)