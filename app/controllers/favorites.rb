class FavoritesController < ApplicationController

  def index
    @groups = Group.roots
  end

  def show

  end

  def showall

  end

  def new
  end

  def destroy
  end

end
