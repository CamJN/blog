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

  test "moderator can create comments" do
    mod = users(:bob)
    sign_in mod

    assert_difference('Comment.count',1) do
      post :create, article_id: articles(:good).id, comment: {body: 'a long enough body'}
    end

    assert_redirected_to article_path(articles(:good).id)
  end

  test "registered can create comments" do
    reg = users(:one)
    sign_in reg

    assert_difference('Comment.count',1) do
      post :create, article_id: articles(:good).id, comment: {body: 'a long enough body'}
    end

    assert_redirected_to article_path(articles(:good).id)
  end

  test "guest cannot create comments" do
    assert_no_difference('Comment.count') do
      post :create, article_id: articles(:good).id, comment: {body: 'a long enough body'}
    end

    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "banned cannot create comments" do
    ban = users(:bad)
    sign_in ban

    assert_no_difference('Comment.count') do
      post :create, article_id: articles(:good).id, comment: {body: 'a long enough body'}
    end

    assert_redirected_to article_path(articles(:good).id)
    assert_not_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "admin can destroy other's comments" do
    admin = users(:ted)
    sign_in admin

    assert_difference('Comment.count',-1) do
      delete :destroy, article_id: articles(:good).id, id: comments(:one).id
    end

    assert_redirected_to article_path(articles(:good).id)
  end

  test "admin can destroy own comments" do
    admin = users(:ted)
    sign_in admin

    assert_difference('Comment.count',-1) do
      delete :destroy, article_id: articles(:good).id, id: comments(:three).id
    end

    assert_redirected_to article_path(articles(:good).id)
  end

  test "moderator can destroy own comments" do
    mod = users(:bob)
    sign_in mod

    assert_difference('Comment.count',-1) do
      delete :destroy, article_id: articles(:good).id, id: comments(:one).id
    end

    assert_redirected_to article_path(articles(:good).id)
  end

  test "moderator can destroy other's comments" do
    mod = users(:bob)
    sign_in mod

    assert_difference('Comment.count',-1) do
      delete :destroy, article_id: articles(:good).id, id: comments(:three).id
    end

    assert_redirected_to article_path(articles(:good).id)
  end

  test "registered can destroy own comments" do
    reg = users(:one)
    sign_in reg

    assert_difference('Comment.count',-1) do
      delete :destroy, article_id: articles(:good).id, id: comments(:four).id
    end

    assert_redirected_to article_path(articles(:good).id)
  end

  test "registered cannot destroy other's comments" do
    reg = users(:one)
    sign_in reg

    assert_no_difference('Comment.count') do
      delete :destroy, article_id: articles(:good).id, id: comments(:one).id
    end

    assert_redirected_to article_path(articles(:good).id)
  end

  test "guest cannot destroy comments" do
    assert_no_difference('Comment.count') do
      delete :destroy, article_id: articles(:good).id, id: comments(:one).id
    end

    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "banned cannot destroy comments" do
    ban = users(:bad)
    sign_in ban

    assert_no_difference('Comment.count') do
      delete :destroy, article_id: articles(:good).id, id: comments(:five).id
    end

    assert_redirected_to article_path(articles(:good).id)
  end
end
