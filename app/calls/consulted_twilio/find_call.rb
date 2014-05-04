module ConsultedTwilio
  class FindCall
    include LightService::Organizer

    def self.for(params)
      digits = params[:Digits]

      with(pin: digits).reduce [
        LookupCall
      ]
    end

    class LookupCall
      include LightService::Action

      executed do |context|
        pin = context.fetch :pin

        if pin.nil?
          context.fail! 'No pin given!'
          next
        end

        begin
          call = Call.active.by_pin(pin).first
          context[:call] = call
          fail if call.nil?
        rescue => e
          context.fail! 'The entered pin was not correct!'
          Rails.logger.info e
        end
      end
    end
  end
end
