class ProfilesController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :set_recommend_posts, only: %i[show]
  def show
    @total_my_posts = @user.posts.count
    @total_my_likes = @user.like_posts.count
    @my_posts = @user.posts.includes(:user).order(id: :desc).page(params[:posts_page])
    @my_likes = @user.like_posts.includes(:user).order(id: :desc).page(params[:likes_page])
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

  def set_recommend_posts
    @recommend_posts = current_user.recommend_posts
  end
end
