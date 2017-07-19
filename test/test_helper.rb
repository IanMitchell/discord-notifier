require 'net/http'

# Since refinements don't work with `respond_to` which
# Minitest uses when it stubs methods, we need to monkey
# patch Net::HTTP here for our tests.
unless Net::HTTP.methods.include?(:post)
  class Net::HTTP
    def self.post(url, data, header = nil)
      start(url.hostname, url.port,
            :use_ssl => url.scheme == 'https' ) {|http|
        http.post(url.path, data, header)
      }
    end
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'discord_notifier'
require 'discord_notifier/version'

require 'minitest/autorun'

def test_attachment
  Dir.chdir(File.dirname(__FILE__))
  File.open('test_attachment.txt')
end
