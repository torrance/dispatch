class ArticlesController < ApplicationController
  def new
    @article = Article.new
    2.times { @article.images.build }
  end

  def create
    @article = Article.new(params[:article])
    @article.user = current_user

    if @article.save
      redirect_to @article, notice: 'Your article was successfully created.'
    else
      2.times { @article.images.build }
      render action: "new"
    end
  end

  def edit
    @article = Article.find(params[:id])
    2.times { @article.images.build }
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