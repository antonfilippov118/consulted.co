module CurrencyFilter
  include ActionView::Helpers::NumberHelper

  def currency(number, unit = '')
    number_to_currency number, unit: unit
  end

end
