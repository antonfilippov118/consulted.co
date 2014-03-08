class GroupsController < ApplicationController
  def index
    @groups = Group.roots
  end

  def show
    @group = Group.find params[:id]
    result = FindsAvailableExperts.for @group
    @experts = result[:experts]
  end
end
