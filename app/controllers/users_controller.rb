class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, success: t('users.create.success')
    else
      flash[:danger] = t('users.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :prefecture_id, :age_group, :email, :avatar, :avatar_cache, :password, :password_confirmation)
  end
end
