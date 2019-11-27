require 'json'
require 'net/http'
require 'net/https'
require_relative 'discord_notifier/embed'
require_relative 'discord_notifier/form_data'
require_relative 'discord_notifier/backports/hash'
require_relative 'discord_notifier/backports/http'

module Discord
  using Backports

  Config = Struct.new(:url, :username, :avatar_url, :wait)

  module Notifier
    @@config = Config.new

    def self.setup
      yield @@config
    end

    def self.message(content, config = {})
      params = payload(content, config)

      if params[:file]
        send_form(params)
      else
        send_request(params)
      end
    end

    def self.payload(content, config)
      payload = @@config.to_h.merge(config)

      case content
      when String
        payload[:content] = content
      when Embed
        payload[:embeds] = [content.data]
      when Array
        payload[:embeds] = content.map { |embed| embed.data }
      when File
        payload[:file] = content
      else
        raise ArgumentError, 'Unsupported content type'
      end

      payload.compact
    end

    def self.send_request(params)
      Net::HTTP.post endpoint(params),
                     params.to_json,
                     { 'Content-Type' => 'application/json' }
    end

    def self.send_form(params)
      uri = endpoint(params)

      req = Discord.form_data_request(uri, params)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.request(req)
    end

    def self.endpoint(config)
      uri = URI(config[:url])
      uri.query = URI.encode_www_form(wait: true) if config[:wait]
      return uri
    end
  end
end
