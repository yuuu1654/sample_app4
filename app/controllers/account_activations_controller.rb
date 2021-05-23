class AccountActivationsController < ApplicationController

  # GET /account_activations/:id/edit
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])#中身はtoken
      user.activate
      log_in user
      flash[:success] = "有効化しやした！"
      redirect_to user
    else
      flash[:danger] = "有効化出来まへん！！"
      redirect_to root_path
    end
  end

end
