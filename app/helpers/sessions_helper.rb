module SessionsHelper
  def current_user
    # 現在ログインしているユーザを取得する
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !!current_user
  end
end
