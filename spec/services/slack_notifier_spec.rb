require 'rails_helper'

RSpec.describe SlackNotifier do
  before do
    allow(URI).to receive(:parse).and_return(uri)

    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:use_ssl=)

    allow(Net::HTTP::Post).to receive(:new).and_return(http_post)
    allow(http_post).to receive(:body=).with({ "text": 'Hello, World!' }.to_json)

    allow(http).to receive(:request)

    SlackNotifier.post('Hello, World!')
  end

  let(:uri) { instance_double(URI::HTTP, host: 'localhost', port: 3000, request_uri: '') }
  let(:http) { instance_double(Net::HTTP) }
  let(:http_post) { instance_double(Net::HTTP::Post) }

  it 'uses the right URI' do
    expect(URI).to have_received(:parse).with('https://hooks.slack.com/services/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')
  end

  it 'sends post request' do
    expect(http).to have_received(:request).with(http_post)
  end

  it 'sends request with correct body' do
    body = { "text": 'Hello, World!' }.to_json

    expect(http_post).to have_received(:body=).with(body)
  end
end
