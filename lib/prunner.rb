require_relative 'client'
require_relative 'result'

# the class +Prunner+ is responsible for trimming data and
# returning only selected tree according to its +path+
class Prunner

  def initialize(path: default_path, client: default_client)
    @path = path
    @client = client
  end

  def call(ids = [])
    result = client.tree
    return result unless result.success?
    return result if ids.empty?
    tree = prune(result.value, ids, path.first)
    Result.new(tree)
  end

  private

  attr_reader :client, :path

  def prune(collection, ids, key)
    collection.select do |item|
      next if ids.empty?
      if key
        next_key = path[path.index(key).next]
        item[key] = prune(item[key], ids, next_key)
        item[key].any?
      else
        ids.delete(item['id'])
      end
    end
  end

  def default_path
    %w(sub_themes categories indicators)
  end

  def default_client
    Client.new
  end
end
