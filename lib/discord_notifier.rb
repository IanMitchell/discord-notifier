require 'json'
require 'net/http'
require_relative 'discord_notifier/embed'

module Discord
  Config = Struct.new(:url, :username, :avatar_url, :wait)

  class Notifier
    @@config = Config.new

    def self.setup
      yield @@config
    end

    def self.message(content, config = {})
      params = @@config.to_h.merge(config).compact

      case content
      when String
        params[:content] = content
      when Embed
        params[:embeds] = [content.data]
      when Array
        params[:embeds] = content.map { |embed| embed.data }
      # when Attachment
      else
        raise ArgumentError, 'Unsupported content type'
      end

      uri = endpoint(params)
      Net::HTTP.post(uri, params.to_json, "Content-Type": "application/json")
    end

    def self.endpoint(config)
      uri = URI(config[:url])
      uri.query = URI.encode_www_form(wait: true) if config[:wait]
      return uri
    end
  end
end
