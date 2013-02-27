require File.expand_path('../lib/face.rb', __FILE__)
require 'net-http-spy'

Net::HTTP.http_logger_options = {:body => true, :trace => true, :verbose => true}

client = Face.get_client()
data_namespace = "openlibrary"
training_data_dir = File.expand_path('./training-data/*')


def detect_and_tag_user(photo, user_id, client)
    detection_response = client.faces_detect(:file => File.new(photo, 'rb'))
    detected_tag_id = detection_response['photos'].first['tags'].first['tid']
    client.tags_save({:uid => user_id, :tids => detected_tag_id})
end

all_users = Dir.glob(training_data_dir).select { |f| File.directory? f}

all_users.each {|user|
    user_name = File.basename(user)
    p "Training data for : " + user_name
    user_id =  user_name + "@" + data_namespace
    Dir[user +'/*.jpg'].each {|photo|
        detect_and_tag_user(photo, user_id, client)
    }

    client.faces_train(:uids => user_id, :namespace => data_namespace)
}

