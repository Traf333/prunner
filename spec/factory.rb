module Factory
  def word
    ('a'..'z').to_a.sample(10).join
  end

  def base_attrs
    {
      'id' => rand(10 ** 4),
      'name' => word
    }
  end

  def build_indicator(attrs = {})
    base_attrs.merge(attrs)
  end

  def build_category(attrs = {})
    {
      'unit' => word,
      'indicators' => [build_indicator]
    }.merge(base_attrs).merge(attrs)
  end

  def build_sub_theme(attrs = {})
    { 'categories' => [build_category] }.merge(base_attrs).merge(attrs)
  end

  def build_theme(attrs = {})
    { 'sub_themes' => [build_sub_theme] }.merge(base_attrs).merge(attrs)
  end
end
