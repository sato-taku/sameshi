class SaunasController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @saunas = Sauna.all
  end

  def show
    @sauna = Sauna.find(params[:id])
  end

  def autocomplete
    @saunas = Sauna.where('name LIKE ?', "%#{params[:term]}%").limit(10)
    render partial: 'saunas/sauna', locals: { saunas: @saunas }
  end

  def search
    @saunas = Sauna.search_by_name(params[:query]) if params[:query].present?
    respond_to do |format|
      format.json { render json: @saunas }
    end
  end
end
