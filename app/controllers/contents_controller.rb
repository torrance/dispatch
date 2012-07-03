class ContentsController < ApplicationController
  before_filter :initialize_content_names

  def new
    @content = params[:type].constantize.new
    2.times { |weight| @content.images.build(:weight => weight) }
  end

  def create
    @content = params[:type].constantize.new(params[content_type_key])
    @content.user = current_user

    if (current_user || valid_captcha?(@content)) && @content.save
      redirect_to @content, notice: "Your #{@type} was successfully created."
    else
      (998..999).each { |weight| @content.images.build(:weight => weight) }
      render action: "new"
    end
  end

  def edit
    @content = Content.find(params[:id])
    (998..999).each { |weight| @content.images.build(:weight => weight) }
  end

  def update
    @content = Content.find(params[:id])
    if @content.update_attributes(params[content_type_key])
      redirect_to @content, notice: "Your #{@type} was sucessfully updated."
    else
      (998..999).each { |weight| @content.images.build(:weight => weight) }
      render action: "edit"
    end
  end

  def show
    @content = Content.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    @content = Content.find(params[:id])
    if @content.destroy
      redirect_to :root, :notice => "Your #{@type} has been deleted."
    else
      redirect_to :back, :notice => "An error occurred trying to delete your #{@type}"
    end
  end

  def moderate
    @content = Content.find(params[:id])
    @content.status = params[:status]
    if @content.save
      redirect_to :back
    else
      redirect_to :back, :notice => "An error occurred moderating this content."
    end
  end

  protected
  def content_type_key
    params[:type].downcase
  end

  def initialize_content_names
    if params[:type].present?
      @type = params[:type].downcase
    end
  end
end