module ConsultedTwilio
  class EnterPin

    attr_accessor :xml

    def initialize
      @xml = ConsultedTwilio.response.new do |r|
        r.Gather action: '/call/find', numDigits: 6, timeout: 15 do
          r.Say 'Please enter your PIN code', voice: 'woman'
        end
        r.Redirect
      end.text
    end
  end
end
