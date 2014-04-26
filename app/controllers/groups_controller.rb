class GroupsController < ApplicationController
  layout 'offering', only: :show
  include SearchHelper
  def index
    @groups = Group.roots
  end

  def show
    @group = Group.find params[:id]
    redirect_to search_path if @group.children?
    experts = User.experts.with_group(@group)
    @rates = []
    @experience = []
  end

  def search
    result = FindsGroup.for search_params.fetch(:text)
    @groups = result.fetch :groups
  end

  private

  def search_params
    params.permit :text
  end
end
