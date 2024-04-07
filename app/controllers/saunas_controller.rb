class SaunasController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @saunas = Sauna.all
  end

  def show
    @sauna = Sauna.includes(:posts).find(params[:id])
    @posts = @sauna.posts.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def autocomplete
    @saunas = Sauna.where('name LIKE ?', "%#{params[:q]}%").limit(10)
    render partial: 'saunas/sauna', locals: { saunas: @saunas }
  end
end
