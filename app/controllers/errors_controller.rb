class ErrorsController < ApplicationController

  def show
    title! status_title
    render status_code.to_s, status: status_code
  end

  private

  def status_code
    params[:code] || 500
  end

  def status_title
    {
      '404' => 'Page not found',
      '422' => 'Rejected',
      '500' => 'Server error'
    }.fetch status_code
  end
end
