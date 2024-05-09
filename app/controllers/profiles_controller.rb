class ProfilesController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  def show
    @total_my_posts = @user.posts.count
    @total_my_likes = @user.like_posts.count
    @my_posts = @user.posts.includes(:user).order(id: :desc).page(params[:posts_page])
    @my_likes = @user.like_posts.includes(:user).order(id: :desc).page(params[:likes_page])
    @recommend_posts = @user.recommend_posts
  end
  
  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: "ユーザーを更新しました"
    else
      flash.now[:danger] = "ユーザーを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:nickname, :prefecture_id, :age_group, :email, :avatar, :avatar_cache)
  end
end
