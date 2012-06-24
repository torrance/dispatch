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

  def show
    @article = Article.find(params[:id])
  end 
end