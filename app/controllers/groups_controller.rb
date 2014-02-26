class GroupsController < ApplicationController
  respond_to :json
  def show
    render json: Group.roots.all, only: [:name], methods: :sib
  end
end