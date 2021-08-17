require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
  def setup
    #fixtureからユーザーデータを引っ張ってきて、ログインしている状態を作っておく
    @user = users(:yuuu)
    @other = users(:azusa)
    log_in_as(@user)
  end

#following/followersページのテスト

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  #[Follow]/[Unfollow]ボタンをテストする

  test "should follow a user the standard way" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end


  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference "@user.following.count", -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference "@user.following.count", -1 do
      delete relationship_path(relationship), xhr: true
    end
  end


end
