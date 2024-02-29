class SaunasController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  def index
    @saunas = Sauna.all
  end
end
