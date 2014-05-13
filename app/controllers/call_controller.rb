class CallController < ApplicationController
  skip_before_action :verify_authenticity_token

  # no investor needed for this
  skip_before_filter :authenticate!

  def welcome
    render xml: ConsultedTwilio::Welcome.new.xml
  end

  def enter_pin
    render xml: ConsultedTwilio::EnterPin.new(message).xml
  end

  def lookup
    result = ConsultedTwilio::FindCall.for params
    if result.failure?
      xml = ConsultedTwilio::Error.generate result.message, redirect: '/call/enter?message=false'
    else
      call = result.fetch :call
      xml = ConsultedTwilio::OpensConferenceCall.for call: call
    end
    render xml: xml
  end

  private

  def message
    params[:message] != 'false'
  end
end
