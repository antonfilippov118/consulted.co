class Users::FavoritesController < Users::BaseController

  def index

    @favorites = @user.favorites
  end

  def update
    id = params[:id]
    expert = User.find(id)
    @fav = @user.favorites.where(user_id: id)

    if @fav.exists? == true
      @fav.destroy
    else
      @user.favorites.new user: expert, user_id: id
      @user.save
    end
    # binding.pry
  end

end
