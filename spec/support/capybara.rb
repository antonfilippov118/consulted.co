Capybara.javascript_driver = :webkit
Capybara.default_wait_time = 10

class Capybara::Node::Simple
  module AddWithin
    def within(selector)
      yield find(selector)
    end
  end
  include AddWithin
end
