class ArticlesController < ApplicationController
  def new
    @article = Article.new
    2.times { |weight| @article.images.build(:weight => weight) }
  end

  def create
    @article = Article.new(params[:article])
    @article.user = current_user

    if (current_user || valid_captcha?(@article)) && @article.save
      redirect_to @article, notice: 'Your article was successfully created.'
    else
      (998..999).each { |weight| @article.images.build(:weight => weight) }
      render action: "new"
    end
  end

  def edit
    @article = Article.find(params[:id])
    (998..999).each { |weight| @article.images.build(:weight => weight) }
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      redirect_to @article, notice: 'Your article was sucessfully updated.'
    else
      render action: "edit"
    end
  end

  def show
    @article = Article.find(params[:id])
  end 
end