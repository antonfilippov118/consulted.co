module ConsultedTwilio
  class Error
    def self.generate(txt, opts = {})
      opts = defaults.merge opts
      ConsultedTwilio.response.new do |r|
        r.Say txt, voice: opts[:voice]
        if opts[:redirect]
          r.Redirect opts[:redirect]
        end
      end.text
    end

    private

    def self.defaults
      {
        voice: ConsultedTwilio::VOICE,
        redirect: nil
      }
    end
  end
end
