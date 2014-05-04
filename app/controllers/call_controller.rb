class CallController < ApplicationController
  skip_before_action :verify_authenticity_token

  # no investor needed for this
  skip_before_filter :authenticate!

  def handle
    render xml: ConsultedTwilio::EnterPin.new.xml
  end

  def lookup
    result = ConsultedTwilio::FindCall.for params
    if result.failure?
      xml = ConsultedTwilio::Error.generate result.message, redirect: '/call'
    else
      call = result.fetch :call
      xml = ConsultedTwilio::OpensConferenceCall.for call: call
    end
    render xml: xml
  end
end
