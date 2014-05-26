class Users::FavoritesController < Users::BaseController

  def index
    @favorites = User.where id: { :$in => @user.favorites.map(&:favorite_id) }
  end

  def update
    @expert = User.find(id)
    fav = @user.favorites.where(favorite_id: id)

    if fav.exists?
      fav.destroy
    else
      @user.favorites.create favorite_id: id
    end
  end

  private

  def id
    params.permit(:id).fetch :id
  end

end
