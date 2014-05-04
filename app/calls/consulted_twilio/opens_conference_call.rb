module ConsultedTwilio
  class OpensConferenceCall
    def self.for(opts = {})
      call = opts.fetch :call

      name = "#{call.seeker.slug}_with_#{call.expert.slug}"
      ConsultedTwilio.response.new do |r|
        r.Dial do
          r.Conference name
        end
      end.text
    end
  end
end
