require 'net/http'

module Discord
  BOUNDARY = "DiscordNotifier"

  def self.form_data_request(uri, params)
    req = Net::HTTP::Post.new(uri)
    req.add_field "Content-Type", "multipart/form-data; boundary=#{BOUNDARY}"
    req.body = Discord.multipart_form_data(params)
    return req
  end

  def self.multipart_form_data(config)
    file = config[:file]
    filename = File.basename(file.path)
    file_contents = File.read(file)
    payload = config.select {|k, v| k != :file}

    form = <<~eos
      --#{BOUNDARY}
      Content-Disposition: form-data; name="file"; filename="#{filename}"

      #{file_contents}

      --#{BOUNDARY}
      Content-Disposition: form-data; name="payload_json"

      #{payload.to_json}

      --#{BOUNDARY}--
    eos
  end
end
