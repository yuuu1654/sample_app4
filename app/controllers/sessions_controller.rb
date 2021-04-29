class SessionsController < ApplicationController
  def new
    # x @session = Session.new
    # o scope: :session + user: login_path
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # ユーザーがデータベースにあり、かつ、認証に成功した場合にのみ
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトされる
      log_in user
      redirect_to user
    else
      flash.now[:danger] = '宜しくないeーマイルとパスワードのコンビネーションダスよ'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
