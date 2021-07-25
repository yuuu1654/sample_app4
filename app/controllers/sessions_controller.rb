class SessionsController < ApplicationController
  def new
    # x @session = Session.new
    # o scope: :session + user: login_path
  end

  #ログイン
  def create
    user = User.find_by(email: params[:session][:email].downcase)

    # ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        # ユーザーログイン後にユーザー情報のページにリダイレクトされる
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "まだ有効化済んでまへんで"
        message += "有効化リンク用のメールチェックしとこか〜"
        flash[:warning] = message
        redirect_to root_path
      end
    else
      flash.now[:danger] = '宜しくないeーマイルとパスワードのコンビネーションだすよ'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
