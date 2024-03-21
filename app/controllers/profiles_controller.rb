class ProfilesController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  def show; end
  
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
