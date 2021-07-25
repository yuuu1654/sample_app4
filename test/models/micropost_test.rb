require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  

  def setup
    @user = users(:yuuu)
    #このコードは慣習的には正しくない
    #@micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  
  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  #初めにバリデーションは書かずにテストだけ書く→redになる
  #バリデーションを書くことで期待通りにはじけるのでテストと同じように動いてgreenになる
  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end

  #6/5
  #マイクロポストの順序付をテストする
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
