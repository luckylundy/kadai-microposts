class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    # お気に入り登録したい投稿をmicropostに代入
    micropost = Micropost.find(params[:micropost_id])
    # ログインユーザー状態でお気に入り登録
    current_user.like(micropost)
    flash[:success] = 'お気に入りに追加しました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unlike(micropost)
    flash[:success] = 'お気に入りを解除しました。'
    redirect_back(fallback_location: root_path)
  end
end
