class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :nested => :article

  def create
    params['comment']['user_id'] = current_user.id
#     @comment = @article.comments.create(comment_params)
    if @comment.id.nil?
      flash[:alert] = 'Comment '+ @comment.errors.messages[:body].first
    end

    redirect_to article_path(@article)
  end

  def destroy
    @comment.destroy
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
end
