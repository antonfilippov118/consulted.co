module ConsultedTwilio
  class Welcome
    attr_reader :xml

    def initialize
      @xml = ConsultedTwilio.response.new do |r|
        r.Say 'Welcome to the consulted call bridge', voice: ConsultedTwilio::VOICE
        r.Redirect '/call/enter'
      end.text
    end
  end
end
