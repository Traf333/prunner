require 'httparty'

class Client
  include HTTParty

  base_uri 'https://kf6xwyykee.execute-api.us-east-1.amazonaws.com/production'

  attr_reader :options

  def initialize(options)
    @options = options
  end

  def indicators
    get('/tree/input')
  end
end
