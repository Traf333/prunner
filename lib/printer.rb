require 'terminal-table'

Theme = Struct.new(:data) do

  def name
    data['name']
  end

  def sub_themes
    data['sub_themes']
  end

  def categories
    sub_themes.map { |sub_theme| sub_theme['categories'] }.flatten
  end

  def indicators
    categories.map { |category| category['indicators'] }.flatten
  end
end

class Printer
  def initialize(tree)
    @tree = tree.map { |item| Theme.new(item) }
  end

  def print
    Terminal::Table.new(headings: headings, rows: rows, style: { width: screen_width })
  end

  private

  def headings
    %w(themes sub_themes categories indicators)
  end

  def rows
    prepared_rows = @tree.map do |item|
      [
        item.name,
        cell(item.sub_themes),
        cell(item.categories),
        cell(item.indicators),
      ]
    end
    insert_separator(prepared_rows)
  end

  def insert_separator(list)
    list.product([:separator]).flatten(1)[0...-1]
  end

  def cell(collection)
    collection.map { |item| cell_row(item) }.join("\n")
  end

  def cell_row(item)
    [item['name'], item['unit']].join(' ')[0...col_width]
  end

  def screen_width
    `tput cols`.to_i
  end

  def col_width
    screen_width / headings.size
  end
end

