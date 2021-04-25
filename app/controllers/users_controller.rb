class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    
  end

  #form_withの引数で必要となるUserオブジェクトを作成
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #保存成功の処理
      flash[:success] = "ようこそサンプルウプにお越しくださいました！"
      redirect_to @user #redirect_to user_url(@user)と同じ
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                    :password_confirmation)
    end

end
