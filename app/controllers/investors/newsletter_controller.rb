class Investors::NewsletterController < ApplicationController
  skip_before_filter :authenticate!
  def register
    @newsletter = Newsletter.new newsletter_params
    unless @newsletter.send!
      render 'error'
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit :email
  end
end
