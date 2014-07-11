require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should create article when admin makes request" do
    sign_in users(:ted)

    #assert_equal 'ted', current_user.username

    assert_difference('Article.count') do
      post :create, article: {title: 'Some title', body: 'a body'}
    end

    assert_redirected_to article_path(assigns(:article))
  end

end
