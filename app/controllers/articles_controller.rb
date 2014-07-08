class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def new
    @article = Article.new
  end

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  alias_method :edit, :show

  def destroy
    show
    @article.destroy
    home
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    show

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  private
  def article_params
    params.require(:article).permit(:title,:text)
  end
  def home
    redirect_to articles_path
  end
end
