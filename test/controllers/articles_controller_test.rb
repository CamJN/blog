require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase

  test "should get index without authenticating" do
    get :index
    assert_response :success
    assert_template :index
  end

  test "getting index should list all articles" do
    get :index
    assert_template :index
    assert_not_nil assigns(:articles)
    assert_equal Article.all.length, assigns(:articles).length
  end


  test "should get show without authenticating" do
    get(:show, {id: articles(:good).id})
    assert_response :success
    assert_template :show
  end

  Article.all.each do |a|
    test "getting show should display specified article "+a.title do
      get(:show, {id: a.id})
      assert_template :show
      assert_not_nil assigns(:article)
      assert_select 'h1', a.title
      assert_equal a.id, assigns(:article).id
    end
  end

  test "should not display new article form when non-admin gets articles#new" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "should display new article form when admin gets articles#new" do
    admin = users(:ted)
    sign_in admin

    get :new
    assert_response :success
    assert_template :new
    assert_template layout: 'layouts/application', partial: '_form'
  end

  test "should populate new article form with new/blank article when admin gets articles#new" do
    admin = users(:ted)
    sign_in admin

    get :new
    assert_nil assigns(:article).id
    assert_nil assigns(:article).title
    assert_nil assigns(:article).text
  end

  test "should create article when admin posts a valid article to articles#create" do
    admin = users(:ted)
    sign_in admin

    assert_difference('Article.count',1) do
      post :create, article: {title: 'Some title', text: 'a body'}
    end

    assert_redirected_to article_path(assigns(:article))
  end

  test "should not create article when admin posts an invalid article to articles#create" do
    admin = users(:ted)
    sign_in admin

    assert_no_difference('Article.count') do
      post :create, article: {title: '', text: 'a body'}
    end
  end

  test "should raise an error and allow correction when admin posts an invalid article to articles#create" do
    admin = users(:ted)
    sign_in admin

    post :create, article: {title: '', text: 'a body'}

    assert_template :new
    assert_not_nil assigns(:article).errors[:title]
  end

  test "should not create article when non admin posts to articles#create" do
    assert_no_difference('Article.count') do
      post :create, article: {title: 'Some title', text: 'a body'}
    end

    assert_response :redirect
    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end


  # get patch put | update edit
  test "should not display edit article form when non-admin gets articles#edit" do
    get(:edit, {id: articles(:good).id})
    assert_response :redirect
    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "should display edit article form when admin gets articles#edit" do
    admin = users(:ted)
    sign_in admin

    get(:edit, {id: articles(:good).id})
    assert_response :success
    assert_template :edit
    assert_template layout: 'layouts/application', partial: '_form'
  end

  test "should populate edit article form with specified article when admin gets articles#edit" do
    admin = users(:ted)
    sign_in admin

    get(:edit, {id: articles(:good).id})
    assert_equal articles(:good).id, assigns(:article).id
  end

  test "should update article when admin puts a valid article to articles#update" do
    admin = users(:ted)
    sign_in admin

    a = articles(:good)

    put :update, id: a.id, article: {title: 'Some title', text: 'a body'}
    assert_redirected_to article_path(assigns(:article))

    assert_equal 'Some title'.titlecase, Article.find(a.id).title
    assert_equal 'a body', Article.find(a.id).text
  end

  test "should not update article when admin puts an invalid article to articles#update" do
    admin = users(:ted)
    sign_in admin

    a = articles(:good)

    put :update, id: a.id, article: {title: 'Some title', text: ''}

    assert_not_equal 'Some title'.titlecase, Article.find(a.id).title
    assert_not_equal '', Article.find(a.id).text
  end

  test "should raise an error and allow correction when admin puts an invalid article to articles#update" do
    admin = users(:ted)
    sign_in admin

    put :update, id: articles(:good).id, article: {title: 'Some title', text: ''}

    assert_template :edit
    assert_not_nil assigns(:article).errors[:title]
  end

  test "should not update article when non admin puts to articles#update" do
    a = articles(:good)

    put :update, id: a.id, article: {title: 'Some title', text: 'a body'}

    assert_not_equal 'Some title'.titlecase, Article.find(a.id).title
    assert_not_equal 'a body', Article.find(a.id).text

    assert_response :redirect
    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "should not destroy article when non admin deletes to articles#destroy" do
    assert_no_difference('Article.count') do
      delete :destroy, id: articles(:good).id
    end

    assert_response :redirect
    assert_redirected_to new_user_session_path
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "should destroy article when admin deletes to articles#destroy" do
    admin = users(:ted)
    sign_in admin

    assert_difference('Article.count',-1) do
      delete :destroy, id: articles(:alsogood).id
    end

    assert_response :redirect
    assert_redirected_to articles_path
  end

end
