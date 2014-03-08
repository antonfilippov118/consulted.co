class FavoritesController < ApplicationController

  def index
    @groups = Group.roots
  end

  def show
    @group = Group.find params[:id]
    result = FindsAvailableExperts.for @group
    @experts = result[:experts]
  end

  def showall

  end

  def new
  end

  def destroy
  end

end
