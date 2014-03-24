class Users::FavoritesController < Users::BaseController

  def index

    @favorites = @user.favorites
  end

  def update
    id = params[:id]
    expert = User.find(id)
    fav = @user.favorites.where(user_id: id)

    if fav.exists? == true
      fav.destroy
      render json: { 'success' => true, 'msg' => 'Remove' }
    else
      @user.favorites.new user: expert, user_id: id
      @user.save
      render json: { 'success' => true, 'msg' => 'Add' }
    end

    render json: { 'success' => false }
  end

end
