require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    #fixtureからデータを引っ張ってくる
    @micropost = microposts(:nattou)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_path
  end

  #間違ったユーザーによる投稿削除に対してのテスト
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:yuuu))
    micropost = microposts(:oppai1)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_path
  end

end
