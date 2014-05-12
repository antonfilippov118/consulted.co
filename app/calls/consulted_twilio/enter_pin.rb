module ConsultedTwilio
  class EnterPin

    attr_accessor :xml

    def initialize
      @xml = ConsultedTwilio.response.new do |r|
        r.Gather action: '/call/find', numDigits: 6, timeout: 15 do
          r.Say 'Welcome to the consulted call bridge', voice: ConsultedTwilio::VOICE
          r.Say 'Please enter your 6 digit personal access code to enter your meeting', voice: ConsultedTwilio::VOICE
        end
        r.Redirect
      end.text
    end
  end
end
