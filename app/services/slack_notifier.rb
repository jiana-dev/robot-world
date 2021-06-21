class SlackNotifier
  def self.post(message)
    header = {'Content-Type': 'text/json'}
    slack_text_data = { "text": message }

    uri = URI.parse('https://hooks.slack.com/services/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')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = slack_text_data.to_json

    http.request(request)
  end
end
