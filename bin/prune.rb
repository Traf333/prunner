require_relative '../lib/prunner'
require_relative '../lib/printer'

ids = ARGV.map(&:to_i)

prunner = Prunner.new
tree = prunner.call(ids)

printer = Printer.new(tree)
puts printer.print
