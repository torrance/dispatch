class TagsController < ApplicationController
  def index
    search = params[:q].downcase

    # Find 5 matching tags, and structure into array in preparation for json.
    @tags = Article.search_tags(search)
    @tags = @tags.map { |t| {id: t.name, name: t.name} }

    # Add option to include new tag if exact match doesn't exist.
    if !@tags.include?({id: search, name: search})
      @tags << {id: search, name: search}
    end

    respond_to do |format|
      format.json { render :json => @tags }
    end
  end
end
