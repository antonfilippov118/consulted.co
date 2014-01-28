class GroupsController < ApplicationController
  def show
    render json: Group.roots.all.as_json(methods: :children)
  end
end
