require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:yuuu)
  end

  #今回の統合テストでは、
  #ログイン、
  #マイクロポストのページ分割の確認、
  #無効なマイクロポストを投稿、
  #有効なマイクロポストを投稿、
  #マイクロポストの削除、
  #そして他のユーザーのマイクロポストには［delete］リンクが表示されないことを確認

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'

    #無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2' #正しいページネーションのリンク
    
    #有効な送信
    content = "Progate復習したらめちゃくちゃいい復習になった"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_match content, response.body

    #投稿を削除する
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    #違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:akane))
    assert_select 'a', text: 'delete', count: 0
  end

end
