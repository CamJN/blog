class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def new
    if can? :create, Article
      @article = Article.new
    else
      home
    end
  end

  def index
    if can? :read, Article
      @articles = Article.all
    else
      @articles = nil
    end
  end

  def show
    if can? :read, Article
      grab
      if cannot? :read, @article
        home
      end
    end
  end

  def edit
    if can? :update, Article
      grab
      if cannot? :update, @article
        home
      end
    else
      home
    end
  end

  def destroy
    if can? :destroy, Article
      grab
      if can? :destroy, @article
        @article.destroy
      end
    end
    home
  end

  def create
    if can? :create, Article
      @article = Article.new(article_params)

      if @article.save
        redirect_to @article
      else
        render 'new'
      end
    else
      home
    end
  end

  def update
    if can? :update, Article
      grab
      if can? :update, @article
        if @article.update(article_params)
          redirect_to @article
        else
          render 'edit'
        end
      else
        home
      end
    else
      home
    end
  end

  private
  def grab
    @article = Article.find(params[:id])
  end
  def article_params
    params.require(:article).permit(:title,:text)
  end
  def home
    redirect_to articles_path
  end
end
