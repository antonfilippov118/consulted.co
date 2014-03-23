module ConsultedTwilio
  class OpensConferenceCall
    def self.for(opts = {})
      call = opts.fetch :call

      name = "#{call.seeker.name.downcase}_with_#{call.expert.name.downcase}_#{Time.now.to_i}"
      ConsultedTwilio.response.new do |r|
        r.Dial do
          r.Conference name
        end
      end
    end
  end
end
