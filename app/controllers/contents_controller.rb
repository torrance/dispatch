class ContentsController < ApplicationController
  before_filter :initialize_content_names

  def new
    @content = content_type.new
    2.times { |weight| @content.images.build(:weight => weight) }
  end

  def create
    @content = content_type.new(params[content_type_key])
    @content.user = current_user

    if (current_user || valid_captcha?(@content)) && @content.save
      redirect_to @content, notice: "Your #{@type} was successfully created."
    else
      (998..999).each { |weight| @content.images.build(:weight => weight) }
      render action: "new"
    end
  end

  def edit
    @content = content_type.find(params[:id])
    (998..999).each { |weight| @content.images.build(:weight => weight) }
  end

  def update
    @content = content_type.find(params[:id])
    if @content.update_attributes(params[:article])
      redirect_to @content, notice: "Your #{@type} was sucessfully updated."
    else
      render action: "edit"
    end
  end

  def show
    @content = content_type.find(params[:id])
  end

  protected

  def content_type
    params[:type].constantize
  end

  def content_type_key
    params[:type].downcase
  end

  def initialize_content_names
    @type = params[:type].downcase
  end
end