class SaunasController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @saunas = Sauna.all
  end

  def show
    @sauna = Sauna.find(params[:id])
  end

  def autocomplete
    @saunas = Sauna.where('name LIKE ?', "%#{params[:q]}%").limit(10)
    render partial: 'saunas/sauna', locals: { saunas: @saunas }
  end
end
