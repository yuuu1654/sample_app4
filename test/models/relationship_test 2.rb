require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  def setup
    @relationship = Relationship.new(follower_id: users(:yuuu).id,
                                      followed_id: users(:akane).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  #follower_idがnilの場合
  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  #followed_idがnilの場合
  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

end
