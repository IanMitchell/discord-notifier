module Discord
  class Embed
    attr_reader :data

    def initialize(&block)
      @data = {}
      self.instance_exec(&block) if block_given?
    end

    def title(str)
      raise ArgumentError, 'Title Embed data must be a String' unless str.is_a?(String)
      @data[:title] = str
    end

    def description(str)
      raise ArgumentError, 'Description Embed data must be a String' unless str.is_a?(String)
      @data[:description] = str
    end

    def url(str)
      raise ArgumentError, 'URL Embed data must be a String' unless str.is_a?(String)
      @data[:url] = str
    end

    def timestamp(date)
      raise ArgumentError, 'Timestamp Embed data must be a Date' unless date.is_a?(DateTime)
      @data[:timestamp] = date
    end

    def color(val)
      case val
      when String
        @data[:color] = val.delete('#').to_i(16)
      when Integer
        raise ArgumentError, 'Color must be 24 bit' if val >= 16_777_216
        @data[:color] = val
      else
        raise ArgumentError, 'Color must be hex or 24 bit int'
      end
    end

    def thumbnail(params)
      raise ArgumentError, "Thumbnail Embed data must be a Hash" unless params.is_a?(Hash)

      @data[:thumbnail] = params
    end

    def video(params)
      raise ArgumentError, "Video Embed data must be a Hash" unless params.is_a?(Hash)

      @data[:video] = params
    end

    def image(params)
      raise ArgumentError, "Image Embed data must be a Hash" unless params.is_a?(Hash)

      @data[:image] = params
    end

    def provider(params)
      raise ArgumentError, "Provider Embed data must be a Hash" unless params.is_a?(Hash)

      @data[:provider] = params
    end

    def author(params)
      raise ArgumentError, "Author Embed data must be a Hash" unless params.is_a?(Hash)

      @data[:author] = params
    end

    def footer(params)
      raise ArgumentError, "Footer Embed data must be a Hash" unless params.is_a?(Hash)

      @data[:footer] = params
    end

    def add_field(params)
      raise ArgumentError, "Field Embed data must be a Hash" unless params.is_a?(Hash)

      @data[:fields] ||= []
      @data[:fields] << params
    end

    alias :field :add_field
  end
end
