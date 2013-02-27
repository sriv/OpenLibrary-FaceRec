module Face
  module Client
    module Tags
      def tags_get(opts={})
        make_request(:tags_get, opts)
      end

      def tags_add(opts={})
        make_request(:tags_add, opts)
      end

      def tags_save(opts={})
        make_request(:tags_save, opts)
      end

      def tags_remove(opts={})
        make_request(:tags_remove, opts)
      end
    end
  end
end