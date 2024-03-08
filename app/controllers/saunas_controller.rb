class SaunasController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  def index
    @saunas = Sauna.all
  end

  def show
    @sauna = Sauna.find(params[:id])
  end

  def search
    @saunas = Sauna.search_by_name(params[:query]) if params[:query].present?
    respond_to do |format|
      format.json { render json: @saunas }
    end
  end
end
