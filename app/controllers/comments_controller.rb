class CommentsController < ApplicationController
  check_authorization # Ensure cancan validation on every controller method
  before_filter :require_user

  def create
    @comment = Comment.new(params[:comment]) do |c|
      c.content = Content.find(params[:content_id])
      c.user = current_user
    end
    authorize! :create, @comment

    if @comment.save
      redirect_to polymorphic_path(@comment.content, :anchor => "comment-#{@comment.id}"),
        :notice => 'Your comment has been successfully created.'
    else
      @content = @comment.content
      render 'contents/show'
    end
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment

    @comment.update_attributes(params[:comment], :as => :editor)

    respond_to do |format|
      format.html do
        redirect_to polymorphic_path(@comment.content, :anchor => "comment-#{@comment.id}")
        flash[:notice] = "An error occurred trying to update comment #{comment.id}" if @comment.errors.any?
      end
      format.js do
        # We don't have to filter for status here, since only editors can access this action.
        @comments = Comment.oldest.where(:content_id => @comment.content)
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment

    @comment.destroy

    respond_to do |format|
      format.html do
        redirect_to polymorphic_path(@comment.content)
        flash[:notice] = "An error occurred trying to delete comment #{comment.id}" if @comment.errors.any?
      end
      format.js do
        # We don't have to filter for status here, since only editors can access this action.
        @comments = Comment.oldest.where(:content_id => @comment.content)
        render :update
      end
    end
  end
end
