class Search
  def initialize(options = {})
    defaults = {
      strategy: FindsAvailableExperts
    }
    options = defaults.merge options
    @group    = options.fetch :group
    @strategy = options.fetch :strategy
  end
end
