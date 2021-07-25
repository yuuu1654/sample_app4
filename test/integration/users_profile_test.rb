require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  #include モジュール名
  #helperで定義したメソッドの塊を渡してあげて使えるようにする
  include ApplicationHelper

  #今回のテストでは、プロフィール画面にアクセスした後に、
  #ページタイトルとユーザー名、Gravatar、マイクロポストの投稿数、
  #そしてページ分割されたマイクロポスト、といった順でテストしていきます。

  def setup
    @user = users(:yuuu)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

end
