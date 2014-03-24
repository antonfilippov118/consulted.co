class Users::FavoritesController < Users::BaseController

  def index

    #@favorites = @user.favorites
    @favorites = User.find @user.favorites.map(&:favorite_id)
  end

  def update
    id = params[:id]
    expert = User.find(id)
    @fav = @user.favorites.where(favorite_id: id)

    if @fav.exists? == true
      @fav.destroy
    else
      @user.favorites.new user: expert, favorite_id: id
      @user.save
    end
    # binding.pry
  end

end
