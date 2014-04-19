class GroupsController < ApplicationController
  include SearchHelper
  def index
    @groups = Group.roots
  end

  def show
    @group = Group.find params[:id]
    redirect_to search_path if @group.children?
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
