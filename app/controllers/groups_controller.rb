class GroupsController < ApplicationController
  def show
    render json: Group.all
  end
end
