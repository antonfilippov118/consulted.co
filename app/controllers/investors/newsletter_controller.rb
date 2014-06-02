class Investors::NewsletterController < ApplicationController
  skip_before_filter :authenticate!
  def register
    respond_to do |format|
      format.js do
        @newsletter = Newsletter.new newsletter_params
        unless @newsletter.send!
          render 'error'
        end
      end
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit :email
  end
end
