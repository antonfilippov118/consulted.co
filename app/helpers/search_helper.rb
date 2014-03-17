module SearchHelper
  def date_options
    {
      'All' => nil,
      'Today' => Date.today,
      'Tomorrow' => Date.tomorrow,
      "#{(Date.today + 2.days).strftime('%a, %d-%m-%Y')}" => Date.today + 2.days,
      "#{(Date.today + 3.days).strftime('%a, %d-%m-%Y')}" => Date.today + 3.days,
      "#{(Date.today + 4.days).strftime('%a, %d-%m-%Y')}" => Date.today + 4.days,
      "#{(Date.today + 5.days).strftime('%a, %d-%m-%Y')}" => Date.today + 5.days,
      "#{(Date.today + 6.days).strftime('%a, %d-%m-%Y')}" => Date.today + 6.days
    }
  end

  def time_options
    {
      'All' => nil,
      'Until 6:00' => '0_6',
      '6:00 to 10:00' => '6_10',
      '10:00 to 14:00' => '10_14',
      '14:00 to 18:00' => '14_18',
      'After 18:00' => '18'

    }
  end
end
