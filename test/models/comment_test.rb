require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # validates :commenter, presence: true, length: {minimum: 2}

  test "comment should not save without body" do
    nobody = Comment.new
    nobody.commenter = "someone"
    nobody.article_id = articles(:good).id
    assert_not nobody.save, "Comment saved with no body"
  end

  test "comment should not save with short body" do
    shortbody = Comment.new
    shortbody.commenter = "someone"
    shortbody.article_id = articles(:good).id
    shortbody.body = 'short'
    assert_not shortbody.save, "Comment saved with no body"
  end

  test "comment should not save with duplicate body" do
    dupbody = Comment.new
    dupbody.commenter = "someone"
    dupbody.article_id = articles(:good).id
    dupbody.body = comments(:one).body
    assert_not dupbody.save, "Comment saved with duplicate body"
  end

end
