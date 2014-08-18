class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create]
  load_and_authorize_resource :article
  load_and_authorize_resource :comment, through: :article

  def create
    if not @comment.save
      flash[:alert] = 'Comment '+ @comment.errors.messages[:body].first
    end

    redirect_to article_path(@article)
  end

  def destroy
    @comment.destroy
    if request.referer.nil?
      redirect_to article_path(@article)
    else
      redirect_to :back
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body,:user_id)
  end
  def set_user
    params['comment']['user_id'] = current_user.id
  end
end
