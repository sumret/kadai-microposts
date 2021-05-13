class ToppagesController < ApplicationController
  def index
    if logged_in?
      @micropost = current_user.microposts.build # from_with用
      @microposts = current_user.microposts.order(id: :desc).page(params[:page])
    end
  end
end
