require 'httparty'

# the class +Client+ is responsible for fetching data tree from the remote server
# It has considered case for unstable servers by retrying the request.
class Client
  include HTTParty

  ExternalError = Class.new(StandardError)

  DEFAULT_RETRY_COUNT = 3

  base_uri 'https://kf6xwyykee.execute-api.us-east-1.amazonaws.com/production'

  attr_reader :options, :error

  def initialize(options = {})
    @options = options
    @error = nil
  end

  def tree
    tries ||= 0
    fetch_tree
  rescue Client::ExternalError => e
    tries += 1
    retry if tries < allowed_retry_count
    @error = e.message
    nil
  end

  private

  def fetch_tree
    self.class.get('/tree/input').tap do |response|
      raise ExternalError.new(response.body) unless response.success?
    end
  end

  def allowed_retry_count
    @options.fetch(:retry, DEFAULT_RETRY_COUNT)
  end
end
