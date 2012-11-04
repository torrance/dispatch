class ContentFiltersController < ApplicationController
  # Given markdown formatted text, return html coverted text.
  def markdown
    if params[:text].nil?
      @html = ''
    else
      @html = { html: Dispatch::ContentFilter.instance.render(params[:text]) }
    end

    respond_to do |format|
      format.json { render :json => @html }
    end
  end
end
