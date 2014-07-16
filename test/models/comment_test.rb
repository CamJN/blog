require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "comment should not be valid without body" do
    nobody = Comment.new
    nobody.user_id = users(:bob).id
    nobody.article_id = articles(:good).id
    assert_not nobody.valid?, "Comment valid with no body"
  end

  test "comment should set error if validated without body" do
    nobody = Comment.new
    nobody.user_id = users(:bob).id
    nobody.article_id = articles(:good).id
    nobody.valid?
    assert_not_nil nobody.errors
    assert_includes nobody.errors.messages[:body], "can't be blank"
  end

  test "comment should not be valid with short body" do
    shortbody = Comment.new
    shortbody.user_id = users(:bob).id
    shortbody.article_id = articles(:good).id
    shortbody.body = 'short'
    assert_not shortbody.valid?, "Comment valid with no body"
  end

  test "comment should set error if validated with short body" do
    nobody = Comment.new
    nobody.user_id = users(:bob).id
    nobody.article_id = articles(:good).id
    nobody.valid?
    assert_not_nil nobody.errors
    assert_includes nobody.errors.messages[:body], "is too short (minimum is 15 characters)"
  end

  test "comment should not be valid with duplicate body" do
    dupbody = Comment.new
    dupbody.user_id = users(:bob).id
    dupbody.article_id = articles(:good).id
    dupbody.body = comments(:one).body
    assert_not dupbody.valid?, "Comment valid with duplicate body"
  end

  test "comment should set error if validated with duplicate body" do
    dupbody = Comment.new
    dupbody.user_id = users(:bob).id
    dupbody.article_id = articles(:good).id
    dupbody.body = comments(:one).body
    dupbody.valid?
    assert_not_nil dupbody.errors
    assert_includes dupbody.errors.messages[:body], 'has already been taken'
  end

end
