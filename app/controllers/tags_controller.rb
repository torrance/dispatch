class TagsController < ApplicationController
  def index
    search = params[:q].downcase

    # Find 5 matching tags, and structure into array in preparation for json.
    @tags = Article.search_tags(search)
    @tags = @tags.map { |t| t.name }

    respond_to do |format|
      format.json { render :json => @tags }
    end
  end
end
