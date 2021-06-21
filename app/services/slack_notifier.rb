class SlackNotifier
  def self.post(message)
    header = {'Content-Type': 'text/json'}
    slack_text_data = { "text": message }

    uri = URI.parse('https://hooks.slack.com/services/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')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = slack_text_data.to_json

    response = http.request(request)
  end
end
