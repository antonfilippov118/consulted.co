class GroupsController < ApplicationController
  layout 'offering', only: :show
  before_filter :service_offering?, only: :show
  include SearchHelper
  def index
    @groups = Group.roots
  end

  def show
    result = DeterminesOffers.for @group
    @rates = result.fetch :rates
    @experience = result.fetch :experience
  end

  private

  def service_offering?
    @group = Group.find params[:id]
    redirect_to search_path if @group.children?
  end
end
