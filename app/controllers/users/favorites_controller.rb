class Users::FavoritesController < Users::BaseController

  def update

    # scope :with_id, -> id { where user => id }
    # @user.favs.with_id(id).exists?
    # gibts raus / add

    # if type == 'favorite'
    #   current_user.favorites << @user
    #   redirect_to :back, notice: 'You favorited #{@user.name}'

    # elsif type == 'unfavorite'
    #   current_user.favorites.delete(@user)
    #   redirect_to :back, notice: 'Unfavorited #{@user.name}'

    # else
    #   # Type missing, nothing happens
    #   redirect_to :back, notice: 'Nothing happened.'
    # end
  end

end
