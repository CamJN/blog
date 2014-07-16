class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    grab_article
    if can? :create, Comment
      params['comment']['user_id'] = current_user.id
      @comment = @article.comments.create(comment_params)
      if @comment.id.nil?
        flash[:alert] = 'Comment '+ @comment.errors.messages[:body].first
      end
    else
      flash[:alert] = 'You are not allowed to do that.'
    end
    redirect_to article_path(@article)
  end

  def destroy
    grab_article
    if can? :destroy, Comment
    @comment = @article.comments.find(params[:id])
      if can? :destroy, @comment
        @comment.destroy
      else
        flash[:alert] = 'You are not allowed to do that.'
      end
    end
    if request.referer.nil?
      redirect_to article_path(@article)
    else
      redirect_to request.referer
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body,:user_id)
  end
  def grab_article
    @article = Article.find(params[:article_id])
  end
end
