require 'test_helper'

#class ArticlesViewTest < ActionView::TestCase
class ArticlesViewTest < ActionController::TestCase

  def setup
     @controller = ArticlesController.new
  end

  Article.all.each do |a|
    test "getting index should list article titles including "+a.title do
      get :index
      assert_template :index
      assert_select 'tr > td:nth-child(1)', {count: 1, text: a.title},
        "Wrong title or more than one title element"
    end

    test "getting show should display specified article "+a.title do
      get(:show, {id: a.id})
      assert_template :show
      assert_select 'h1', a.title
    end

    test "admin getting edit should provide form for editing specified article "+a.title do
      admin = users(:ted)
      sign_in admin

      get(:edit, {id: a.id})
      assert_template :edit
      assert_template partial: '_form'
      assert_select 'input'
    end

    test "non-admin getting edit should not provide form for editing specified article "+a.title do
      get(:edit, {id: a.id})
      assert_template nil
      assert_template partial: false
      assert_select 'input', false
    end
  end

  test "admin getting new should provide form for entering an article" do
    admin = users(:ted)
    sign_in admin

    get :new
    assert_template :new
    assert_template partial: '_form'
    assert_select 'input'
  end

  test "non-admin getting new should not provide form for entering an article" do
    get :new
    assert_template nil
    assert_template partial: false
    assert_select 'input', false
  end

end
