class GroupsController < ApplicationController
  respond_to :json
  def show
    @groups = Group.roots
  end
end
