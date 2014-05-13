module ConsultedTwilio
  class EnterPin

    attr_accessor :xml

    def initialize(message = true)
      @xml = ConsultedTwilio.response.new do |r|
        r.Gather action: '/call/find', numDigits: 6, timeout: 15 do
          r.Say 'Please enter your 6 digit personal access code to enter your meeting', voice: ConsultedTwilio::VOICE if message
        end
        r.Redirect
      end.text
    end
  end
end
