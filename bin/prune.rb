require_relative '../lib/prunner'
require_relative '../lib/printer'

def output(result)
  unless result.success?
    return [result.error.code, result.error.data].join(' - ')
  end

  if result.value.empty?
    return "We couldn't find any indicators. Please, try other ids"
  end

  Printer.new(result.value).print
end

ids = ARGV.map(&:to_i)

prunner = Prunner.new
result = prunner.call(ids)

puts output(result)
