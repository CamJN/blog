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
  end

end
