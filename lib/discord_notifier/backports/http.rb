require 'net/http'

module Discord::Backports
  unless Net::HTTP.methods.include?(:post)
    refine Net::HTTP.singleton_class do
      def post(url, data, header = nil)
        start(url.hostname, url.port,
              :use_ssl => url.scheme == 'https' ) {|http|
          http.post(url.path, data, header)
        }
      end
    end
  end
end
