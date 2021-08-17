class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    #Usersコントローラのコンテキストからマイクロポストをページネーションしたいため
    #（つまりコンテキストが異なるため）、明示的に@microposts変数をwill_paginateに渡す必要があります。
  end

  def index #ユーザーの一覧を表示させるアクション
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

  # GET /users/:id/following
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  # GET /users/:id/followers
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                    :password_confirmation)
    end

    #beforeアクション

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
