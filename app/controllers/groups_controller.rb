class GroupsController < ApplicationController
  include GroupsHelper
  def index
    @groups = Group.roots
  end

  def show
    @group = Group.find params[:id]
    result = FindsAvailableExperts.for @group
    @experts = result[:experts]
  end

  helper GroupsHelper
end
