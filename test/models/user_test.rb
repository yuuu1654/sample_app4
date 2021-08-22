require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a"*61
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a"*255 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  #following/followersメソッドが機能しているかの確認
  test "should follow and unfollow a user" do
    yuuu = users(:yuuu)
    azusa = users(:azusa)
    assert_not yuuu.following?(azusa)
    yuuu.follow(azusa)
    assert yuuu.following?(azusa)
    assert azusa.followers.include?(yuuu)
    yuuu.unfollow(azusa)
    assert_not yuuu.following?(azusa)
  end

  test "feed should have the right posts" do
    yuuu = users(:yuuu)
    akane = users(:akane)
    azusa = users(:azusa)

    #フォローしているユーザーの投稿を確認
    akane.microposts.each do |post_following|
      assert yuuu.feed.include?(post_following)
    end
    #自分自身の投稿を確認
    yuuu.microposts.each do |post_self|
      assert yuuu.feed.include?(post_self)
    end
    #フォローしていないユーザーの投稿を確認
    azusa.microposts.each do |post_unfollowed|
      assert_not yuuu.feed.include?(post_unfollowed)
    end
  end

end
