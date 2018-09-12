require 'httparty'
require_relative './result'

# the class +Client+ is responsible for fetching data tree from the remote server
# It has considered case for unstable servers by retrying the request.
class Client
  include HTTParty

  ExternalError = Class.new(StandardError)

  DEFAULT_RETRY_COUNT = 3

  base_uri 'https://kf6xwyykee.execute-api.us-east-1.amazonaws.com/production'

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def tree
    tries ||= 0
    fetch_tree
  rescue Client::ExternalError => e
    tries += 1
    retry if tries < allowed_retry_count
    Result.error(:external_error, e.message)
  end

  private

  def fetch_tree
    response = self.class.get('/tree/input')
    raise ExternalError.new(response.body) unless response.success?
    Result.new(response)
  end

  def allowed_retry_count
    @options.fetch(:retry, DEFAULT_RETRY_COUNT)
  end
end
