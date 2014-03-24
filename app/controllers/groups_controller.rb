class GroupsController < ApplicationController
  include SearchHelper
  def index
    @groups = Group.roots
  end

  def show
    @group = Group.find params[:id]
    redirect_to search_path if @group.children?

    find_experts(group: @group)
  end
end
