class Users::FavoritesController < Users::BaseController

  def favorite
    type = params[:type]
    if type == 'favorite'
      current_user.favorites << @user
      redirect_to :back, notice: 'You favorited #{@user.name}'

    elsif type == 'unfavorite'
      current_user.favorites.delete(@user)
      redirect_to :back, notice: 'Unfavorited #{@user.name}'

    else
      # Type missing, nothing happens
      redirect_to :back, notice: 'Nothing happened.'
    end
  end

end
