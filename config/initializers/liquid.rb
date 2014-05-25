if defined? Liquid
  Liquid::Template.register_filter(LinkFilter)
  Liquid::Template.register_filter(CurrencyFilter)
end
