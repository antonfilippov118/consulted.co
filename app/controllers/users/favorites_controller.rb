class Users::FavoritesController < Users::BaseController

  def index
    # favorite = User.favorite.all.to_a
    # unless favorite.can_be_an_expert?
    #   return render404
    # end
    # @expert = favorite
  end

  def update

    id = params[:id]
    expert = User.find(id)

    fav = @user.favorites.where(user_id: id)

    if fav.exists? == true
      fav.destroy
      binding.pry
    else
      @user.favorites.new user: expert, user_id: id
    end

    render json:{success: true}
  end

end
