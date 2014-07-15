require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test "admin can create comments" do
    admin = users(:ted)
    sign_in admin

    assert_difference('Comment.count',1) do
      post :create, article_id: articles(:good).id, comment: {body: 'a long enough body'}
    end

    assert_redirected_to article_path(articles(:good).id)
  end

#   test "moderator can create comments" do
#     flunk "unimplemented"
#   end

#   test "registered can create comments" do
#     flunk "unimplemented"
#   end

#   test "guest cannot create comments" do
#     flunk "unimplemented"
#   end

#   test "banned cannot create comments" do
#     flunk "unimplemented"
#   end

#   test "admin can read comments" do
#     flunk "unimplemented"
#   end

#   test "moderator can read comments" do
#     flunk "unimplemented"
#   end

#   test "registered can read comments" do
#     flunk "unimplemented"
#   end

#   test "guest can read comments" do
#     flunk "unimplemented"
#   end

#   test "banned cannot read comments" do
#     flunk "unimplemented"
#   end

#   test "admin can destroy own comments" do
#     flunk "unimplemented"
#   end

#   test "admin can destroy other's comments" do
#     flunk "unimplemented"
#   end

#   test "moderator can destroy own comments" do
#     flunk "unimplemented"
#   end

#   test "moderator can destroy other's comments" do
#     flunk "unimplemented"
#   end

#   test "registered can destroy own comments" do
#     flunk "unimplemented"
#   end

#   test "registered cannot destroy other's comments" do
#     flunk "unimplemented"
#   end

#   test "guest cannot destroy comments" do
#     flunk "unimplemented"
#   end

#   test "banned cannot destroy comments" do
#     flunk "unimplemented"
#   end
end
