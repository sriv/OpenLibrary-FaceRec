module Face
  module Client
    module Utils

      class FaceError < StandardError; end

      API_METHODS = {
        :faces_detect => 'http://api.skybiometry.com/fc/faces/detect.json',
        :faces_recognize => 'http://api.skybiometry.com/fc/faces/recognize.json',
        :faces_train => 'http://api.skybiometry.com/fc/faces/train.json',
        :faces_status => 'http://api.skybiometry.com/fc/faces/status.json',
        :tags_get => 'http://api.skybiometry.com/fc/tags/get.json',
        :tags_add => 'http://api.skybiometry.com/fc/tags/add.json',
        :tags_save => 'http://api.skybiometry.com/fc/tags/save.json',
        :tags_remove => 'http://api.skybiometry.com/fc/tags/remove.json',
        :account_limits => 'http://api.skybiometry.com/fc/account/limits.json',
        :account_users => 'http://api.skybiometry.com/fc/account/users.json'
      }

      def api_crendential
        { :api_key => api_key, :api_secret => api_secret }
      end

      def make_request(api_method, opts={})
        if opts[:urls].is_a? Array
          opts[:urls] = opts[:urls].join(',')
        end

        if opts[:uids].is_a? Array
          opts[:uids] = opts[:uids].join(',')
        end
        p api_method
        response = JSON.parse( RestClient.post(API_METHODS[ api_method ], opts.merge(api_crendential)).body )
        p response
        if %w/success partial/.include?(response['status'])
          response
        elsif response['status'] == 'failure'
          raise FaceError.new("Error: #{response['error_code']}, #{response['error_message']}")
        end
      end
    end
  end
end