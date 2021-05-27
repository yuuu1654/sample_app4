class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワードリセットの手順を載せてあるメールを送りやす"
      redirect_to root_path
    else
      flash.now[:danger] = "emailアドレスが見つかりやせん。。"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      #@userオブジェクトにエラ-メッセージを追加する
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)  #新しいパスワードが正しければ更新する
      log_in @user
      flash[:success] = "パスワードリセットしやした！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    #beforeフィルター

    def get_user
      @user = User.find_by(email: params[:email])
    end

    #正しいユーザーかどうか確認するメソッド
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_path
      end
    end

    #トークンが期限切れかどうか確認する
    def check_expiration
      #コードを動作させる為にUserモデルに以下のメソッドを定義しておく
      if @user.password_reset_expired?
        flash[:danger] = "Password reset は期限切れダス."
        redirect_to new_password_reset_url
      end
    end
  
end
