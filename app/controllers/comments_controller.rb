# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.save!
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.comments.find(params[:id]).destroy
    redirect_to root_path, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :commentable_id, :commentable_type).merge(user_id: current_user.id)
  end
end
