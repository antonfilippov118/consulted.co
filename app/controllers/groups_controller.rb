class GroupsController < ApplicationController
  def index
    @groups = Group.roots
  end

  def show
    @group = Group.find params[:id]
    redirect_to search_path if @group.children?

    result = FindsAvailableExperts.for @group
    @experts = result[:experts]
  end
end
