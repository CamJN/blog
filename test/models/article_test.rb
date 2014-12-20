require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  test "article should not be valid without title" do
    notitle = Article.new
    notitle.text = 'acceptable'
    assert_not notitle.valid?, "validated the article without a title"
  end

  test "article without title should set error when validated" do
    notitle = Article.new
    notitle.text = 'acceptable'
    notitle.valid?
    assert_includes notitle.errors.messages[:title], "can't be blank"
  end

  test "article should not be valid with too short of a title" do
    notitle = Article.new
    notitle.text = 'acceptable'
    notitle.title = 'shrt'
    assert_not notitle.valid?, "validated the article with a short title"
  end

  test "article with short title should set error when validated" do
    notitle = Article.new
    notitle.text = 'acceptable'
    notitle.title = 'shrt'
    notitle.valid?
    assert_includes notitle.errors.messages[:title], "is too short (minimum is 5 characters)"
  end

  test "article should not be valid with too long of a title" do
    notitle = Article.new
    notitle.text = 'acceptable'
    notitle.title = 't'*260
    assert_not notitle.valid?, "validated the article with a long title"
  end

  test "article with long title should set error when validated" do
    notitle = Article.new
    notitle.text = 'acceptable'
    notitle.title = 't'*260
    notitle.valid?
    assert_includes notitle.errors.messages[:title], "is too long (maximum is 255 characters)"
  end

  test "article's title setter should title-case the title" do
    notitle = Article.new
    notitle.title = 'this title is too lowercase'
    assert_equal 'This Title Is Too Lowercase', notitle.title, "Didn't title-case the title when it was set"
  end

  test "article with acceptable title should be valid" do
    good = Article.new
    good.title = 'acceptable'
    good.text = 'acceptable'
    assert good.valid?, "Didn't validate the article with a valid title"
  end

  test "article with duplicate title should not be valid" do
    duptitle = Article.new
    duptitle.text = 'acceptable'
    duptitle.title = articles(:good).title
    assert_not duptitle.valid?, "validated article with a duplicate title"
  end

  test "article with duplicate title should set error when validated" do
    duptitle = Article.new
    duptitle.text = 'acceptable'
    duptitle.title = articles(:good).title
    duptitle.valid?
    assert_includes duptitle.errors.messages[:title], "has already been taken"
  end

  test "article should not be valid without text" do
    notext = Article.new
    notext.title = 'acceptable'
    assert_not notext.valid?, "validated the article without text"
  end

  test "article without text should set error when validated" do
    notext = Article.new
    notext.title = 'acceptable'
    notext.valid?
    assert_includes notext.errors.messages[:text], "can't be blank"
  end

  test "article should not be valid with degenerate string text" do
    notext = Article.new
    notext.title = 'acceptable'
    notext.text = ''
    assert_not notext.valid?, "validated the article with degenerate string text"
  end

  test "article with short text should set error when validated" do
    notext = Article.new
    notext.title = 'acceptable'
    notext.text = ''
    notext.valid?
    assert_includes notext.errors.messages[:text], "is too short (minimum is 1 character)"
  end

  test "article with acceptable text should validate" do
    good = Article.new
    good.title = 'acceptable'
    good.text = 'acceptable'
    assert good.valid?, "Didn't validate the article with valid text"
  end
end
