class CommentsController < ApplicationController
  before_filter :require_user

  def create
    @comment = Comment.new(params[:comment]) do |c|
      c.content = Content.find(params[:content_id])
      c.user = current_user
    end
    if @comment.save
      redirect_to polymorphic_path(@comment.content, :anchor => "comment-#{@comment.id}"),
        :notice => 'Your comment has been successfully created.'
    else
      @content = @comment.content
      render 'contents/show'
    end
  end
end
