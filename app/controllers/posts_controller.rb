class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  
  def index
    @posts = Post.all
  end
end
