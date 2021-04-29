require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    #ユーザー登録ボタンを押したときに(情報が無効な為に)、
    #ユーザーが作成されない事を確認
    #ユーザー数が（前と後で）同じというよりも、違わない事をテストする
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "", 
                                        email: "user@invalid", 
                                        password: "foo", 
                                        password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User", 
                                        email: "user@example.com", 
                                        password: "password", 
                                        password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
