class GroupsController < ApplicationController
  include SearchHelper
  layout 'find_an_expert', only: :show
  before_filter :service_offering?, only: :show

  def index
    render json: Group.roots.map(&:as_node)
  end

  def show
    result = DeterminesOffers.for @group
    @rates = result.fetch :rates
    @experience = result.fetch :experience
  end

  def search
    result = FindsGroup.for search_params.fetch :text
    @groups = result.fetch :groups
  end

  private

  def service_offering?
    @group = Group.find params[:id]
    redirect_to search_path if @group.children?
  end
end
