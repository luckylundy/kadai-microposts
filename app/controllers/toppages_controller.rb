class ToppagesController < ApplicationController
  def index
    # アクションの最後にデフォルトでrender :indexを呼びだし
    if logged_in?
      @micropost = current_user.microposts.build  # form_with 用
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
    end
  end
end
