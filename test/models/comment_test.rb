require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "comment should not save without body" do
    nobody = Comment.new
    nobody.user_id = users(:bob).id
    nobody.article_id = articles(:good).id
    assert_not nobody.save, "Comment saved with no body"
  end

  test "comment should not save with short body" do
    shortbody = Comment.new
    shortbody.user_id = users(:bob).id
    shortbody.article_id = articles(:good).id
    shortbody.body = 'short'
    assert_not shortbody.save, "Comment saved with no body"
  end

  test "comment should not save with duplicate body" do
    dupbody = Comment.new
    dupbody.user_id = users(:bob).id
    dupbody.article_id = articles(:good).id
    dupbody.body = comments(:one).body
    assert_not dupbody.save, "Comment saved with duplicate body"
  end

end
