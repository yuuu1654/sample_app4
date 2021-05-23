class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  #form_withの引数で必要となるUserオブジェクトを作成
  def new
    @user = User.new
  end

  #ユーザー登録(signup)
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールチェックして有効化しとこかー"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "uプだてしやした！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "抹消しました"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                    :password_confirmation)
    end

    #beforeアクション

    #ログイン済みユーザーかどうかの確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインおねげしヤス"
        redirect_to login_url
      end
    end

    #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    #管理者かどうか確認
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
