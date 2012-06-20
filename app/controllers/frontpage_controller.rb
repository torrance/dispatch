class FrontpageController < ApplicationController
  def show
    @articles = Article.order("created_at DESC").limit(30)
  end
end
