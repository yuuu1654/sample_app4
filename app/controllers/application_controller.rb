class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    #ログイン済みユーザーかどうかの確認
    def logged_in_user
      unless logged_in? #sessions_helper.rbメソッド定義している
        store_location
        flash[:danger] = "ログインおねげしヤス"
        redirect_to login_url
      end
    end
end
